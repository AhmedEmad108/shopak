import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:shopak/core/utils/backend_endpoint.dart';
import 'package:shopak/features/3-auth/domain/entities/user_entity.dart';
import 'package:shopak/features/6-admin_panel/data/repos/users_repo_impl.dart';
import 'package:shopak/features/6-admin_panel/domain/repos/users_repo.dart';
part 'all_users_state.dart';

class AllUsersCubit extends Cubit<AllUsersState> {
  AllUsersCubit(this.userRepo) : super(AllUsersInitial()) {
    initialize();
    // _startListeningToDataChanges();
  }

  final UsersRepo userRepo;
  StreamSubscription? _dataSubscription;
  bool _isLoading = false;
  bool isUpdating = false;
  String _lastSearchQuery = '';
  Timer? _searchDebouncer;
  bool _isFiltered = false;
  Map<String, dynamic> _lastFilter = {};
  final List<UserEntity> users = [];
  List<UserEntity> allUsers = [];

  void initialize() {
    getAllUsers();
    _startListeningToDataChanges();
  }

  void _startListeningToDataChanges() {
    _dataSubscription = FirebaseFirestore.instance
        .collection(BackendEndpoint.userData)
        .snapshots()
        .listen((snapshot) {
          if (!_isLoading && !_isLoading) {
            _refreshDataWithCurrentFilter();
          }
        });
  }

  Future<void> _refreshDataWithCurrentFilter() async {
    try {
      final result = await userRepo.getUser(
        status: _isFiltered ? _lastFilter['isActive'] : null,
      );
      final statsResult = await userRepo.getUserStats();

      result.fold((failure) => emit(GetUsersFailed(error: failure.message)), (
        users,
      ) {
        allUsers = users;

        List<UserEntity> filteredUsers =
            _isFiltered
                ? users
                    .where((user) => user.isActive == _lastFilter['isActive'])
                    .toList()
                : users;

        if (_lastSearchQuery.isNotEmpty) {
          final searchQuery = _lastSearchQuery.toLowerCase();
          filteredUsers =
              filteredUsers.where((user) {
                return user.name.toLowerCase().contains(searchQuery) ||
                    user.email.toLowerCase().contains(searchQuery);
              }).toList();
        }

        statsResult.fold(
          (failure) => emit(GetUsersFailed(error: failure.message)),
          (stats) {
            if (state is GetUsersSuccess) {
              emit(
                GetUsersSuccess(users: filteredUsers, activeInactive: stats),
              );
            }
          },
        );
      });
    } catch (e) {
      emit(GetUsersFailed(error: e.toString()));
    }
  }

  Future<void> refresh() async {
    if (_isLoading) return;

    _isLoading = true;
    try {
      emit(GetUsersLoading());
      final result = await userRepo.getUser(
        status: _isFiltered ? _lastFilter['isActive'] : null,
      );

      final statsResult = await userRepo.getUserStats();

      result.fold(
        (failure) {
          emit(GetUsersFailed(error: failure.message));
        },
        (users) {
          allUsers = users;

          List<UserEntity> filteredUsers =
              _isFiltered
                  ? users
                      .where((user) => user.isActive == _lastFilter['isActive'])
                      .toList()
                  : users;

          if (_lastSearchQuery.isNotEmpty) {
            final searchQuery = _lastSearchQuery.toLowerCase();
            filteredUsers =
                filteredUsers.where((user) {
                  return user.name.toLowerCase().contains(searchQuery) ||
                      user.email.toLowerCase().contains(searchQuery);
                }).toList();
          }

          statsResult.fold(
            (failure) => emit(GetUsersFailed(error: failure.message)),
            (stats) {
              emit(
                GetUsersSuccess(users: filteredUsers, activeInactive: stats),
              );
            },
          );
        },
      );
    } finally {
      _isLoading = false;
    }
  }

  Future<void> updateUserStatus({
    required String userId,
    required bool newStatus,
  }) async {
    if (_isLoading) return;

    try {
      _isLoading = true;

      ///
      emit(UpdateUsersStatusLoading());

      final result = await userRepo.updateUserStatus(
        userId: userId,
        newStatus: newStatus,
      );

      if (isClosed) return;
      result.fold(
        (failure) => emit(UpdateUsersStatusFailure(failure.message)),
        (_) async {
          // تحديث المستخدم في القائمة المحلية
          allUsers =
              allUsers.map((user) {
                if (user.uId == userId) {
                  return user.copyWith(isActive: newStatus);
                }
                return user;
              }).toList();

          // تحديث الإحصائيات محلياً
          final activeCount = allUsers.where((user) => user.isActive).length;
          final inactiveCount = allUsers.length - activeCount;

          emit(UpdateUsersStatusSuccess());

          emit(
            GetUsersSuccess(
              users:
                  _isFiltered
                      ? allUsers
                          .where(
                            (user) => user.isActive == _lastFilter['isActive'],
                          )
                          .toList()
                      : allUsers,
              activeInactive: ActiveInactive(
                active: activeCount,
                inActive: inactiveCount,
              ),
              // activeFilter: _isFiltered ? _lastFilter['isActive'] : null,
              // isFiltered: _isFiltered,
              // searchQuery: _lastSearchQuery,
            ),
          );

          // await refresh();
        },
      );

      // emit(UpdateUsersStatusSuccess());
      // await refresh();
    } catch (e) {
      if (!isClosed) {
        emit(UpdateUsersStatusFailure(e.toString()));
      }
    } finally {
      _isLoading = false;
    }
  }

  Future<void> filterUsers({bool? status}) async {
    _isFiltered = status != null;
    _lastFilter = {'isActive': status};
    await refresh();
  }

  Future<void> searchUsers(String query) async {
    try {
      // إظهار حالة التحميل
      emit(GetUsersLoading());

      _lastSearchQuery = query.trim().toLowerCase();

      if (_lastSearchQuery.isEmpty) {
        await refresh();
        return;
      }

      final searchResults =
          allUsers.where((user) {
            final matchesName = user.name.toLowerCase().contains(
              _lastSearchQuery,
            );
            final matchesEmail = user.email.toLowerCase().contains(
              _lastSearchQuery,
            );

            if (_isFiltered) {
              return (matchesName || matchesEmail) &&
                  user.isActive == _lastFilter['isActive'];
            }
            return matchesName || matchesEmail;
          }).toList();

      final stats = await userRepo.getUserStats();

      stats.fold(
        (failure) => emit(GetUsersFailed(error: failure.message)),
        (activeInactive) => emit(
          GetUsersSuccess(users: searchResults, activeInactive: activeInactive),
        ),
      );
    } catch (e) {
      emit(GetUsersFailed(error: e.toString()));
    }
  }

  Future<void> editUserData({required UserEntity userEntity}) async {
    emit(EditUsersLoading());
    var result = await userRepo.updateUser(userEntity: userEntity);
    result.fold(
      (failure) {
        emit(EditUsersFailed(errMessage: failure.message));
      },
      (_) {
        emit(EditUsersSuccess());
        refresh();
      },
    );
  }

  Future<void> deleteUser({required String id}) async {
    emit(DeleteUsersLoading());
    var result = await userRepo.deleteUser(id: id);
    result.fold(
      (failure) {
        emit(DeleteUsersError(errMessage: failure.message));
      },
      (_) {
        emit(DeleteUsersSuccess());
        refresh();
      },
    );
  }

  Future<void> getActiveUsers() async {
    await filterUsers(status: true);
  }

  Future<void> getAllUsers() async {
    await filterUsers();
  }

  Future<void> getInactiveUsers() async {
    await filterUsers(status: false);
  }

  @override
  Future<void> close() async {
    await _dataSubscription?.cancel();
    _searchDebouncer?.cancel();
    users.clear();
    allUsers.clear();
    return super.close();
  }
}
