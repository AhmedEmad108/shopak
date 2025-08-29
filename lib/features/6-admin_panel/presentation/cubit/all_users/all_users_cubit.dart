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
    _startListeningToDataChanges();
  }

  final UsersRepo userRepo;
  StreamSubscription? _dataSubscription;
  bool _isLoading = false;
  bool _isUpdating = false;
  String _lastSearchQuery = '';
  Timer? _searchDebouncer;
  bool _isFiltered = false;
  Map<String, dynamic> _lastFilter = {'isActive': null};
  final List<UserEntity> users = [];
  List<UserEntity> allUsers = [];

  void _startListeningToDataChanges() {
    _dataSubscription = FirebaseFirestore.instance
        .collection(BackendEndpoint.userData)
        .snapshots()
        .listen((snapshot) {
          if (!_isLoading && !_isUpdating) {
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
              emit(GetUsersSuccess(users: filteredUsers, activeInactive: stats));
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
              emit(GetUsersSuccess(users: filteredUsers, activeInactive: stats));
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
    if (_isUpdating) return;

    try {
      _isUpdating = true;
      emit(UpdateUsersStatusLoading());

      await userRepo.updateUserStatus(userId: userId, newStatus: newStatus);

      emit(UpdateUsersStatusSuccess());
      await refresh();
    } catch (e) {
      emit(UpdateUsersStatusFailure(e.toString()));
    } finally {
      _isUpdating = false;
    }
  }

  Future<void> filterUsers({bool? status}) async {
    _isFiltered = status != null;
    _lastFilter = {'isActive': status};
    await refresh();
  }

  Future<void> searchUsers(String query) async {
    _lastSearchQuery = query;

    if (query.trim().isEmpty) {
      await refresh();
      return;
    }

    final searchQuery = query.toLowerCase();
    final filteredUsers =
        allUsers.where((user) {
          final matchesName = user.name.toLowerCase().contains(searchQuery);
          final matchesEmail = user.email.toLowerCase().contains(searchQuery);

          if (_isFiltered) {
            return (matchesName || matchesEmail) &&
                user.isActive == _lastFilter['isActive'];
          }

          return matchesName || matchesEmail;
        }).toList();

    emit(
      GetUsersSuccess(
        users: filteredUsers,
        activeInactive: (state as GetUsersSuccess).activeInactive,
      ),
    );
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
