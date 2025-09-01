import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopak/core/utils/backend_endpoint.dart';
import 'package:shopak/features/3-auth/domain/entities/user_entity.dart';
import 'package:shopak/features/6-admin_panel/data/repos/users_repo_impl.dart';
import 'package:shopak/features/6-admin_panel/domain/repos/users_repo.dart';
import 'package:shopak/features/6-admin_panel/presentation/cubit/all_users/all_users_cubit.dart';


class AllUsersCubit extends Cubit<AllUsersState> {
  AllUsersCubit(this.userRepo) : super(AllUsersInitial()) {
    _initializeUsers();
  }

  final UsersRepo userRepo;
  StreamSubscription? _dataSubscription;
  List<UserEntity> _allUsers = [];
  String _lastSearchQuery = '';
  Timer? _searchDebouncer;
  bool _isFiltered = false;
  bool? _activeFilter;
  bool _isLoading = false;

  void _initializeUsers() {
    getAllUsers();
    _startListeningToDataChanges();
  }

  void _startListeningToDataChanges() {
    _dataSubscription?.cancel();
    _dataSubscription = FirebaseFirestore.instance
        .collection(BackendEndpoint.userData)
        .snapshots()
        .listen((snapshot) {
          if (!isClosed && !_isLoading) {
            refresh();
          }
        });
  }

  List<UserEntity> _applyFilters() {
    var filteredUsers = List<UserEntity>.from(_allUsers);

    if (_isFiltered && _activeFilter != null) {
      filteredUsers =
          filteredUsers
              .where((user) => user.isActive == _activeFilter)
              .toList();
    }

    if (_lastSearchQuery.isNotEmpty) {
      final query = _lastSearchQuery.toLowerCase();
      filteredUsers =
          filteredUsers
              .where(
                (user) =>
                    user.name.toLowerCase().contains(query) ||
                    user.email.toLowerCase().contains(query),
              )
              .toList();
    }

    return filteredUsers;
  }

  Future<void> refresh() async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      emit(GetUsersLoading());

      final result = await Future.wait([
        userRepo.getUser(),
        userRepo.getUserStats(),
      ]);

      if (isClosed) return;

      final usersResult = result[0];
      final statsResult = result[1];

      usersResult.fold(
        (failure) => emit(GetUsersFailed(error: failure.message)),
        (users) {
          _allUsers = users as List<UserEntity>;
          statsResult.fold(
            (failure) => emit(GetUsersFailed(error: failure.message)),
            (stats) {
              final filteredUsers = _applyFilters();
              emit(
                GetUsersSuccess(
                  users: filteredUsers,
                  activeInactive: stats as ActiveInactive,
                  // isFiltered: _isFiltered,
                  // activeFilter: _activeFilter,
                  // searchQuery: _lastSearchQuery,
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      if (!isClosed) {
        emit(GetUsersFailed(error: e.toString()));
      }
    } finally {
      _isLoading = false;
    }
  }

  Future<void> searchUsers(String query) async {
    _searchDebouncer?.cancel();

    if (query == _lastSearchQuery) return;

    _searchDebouncer = Timer(const Duration(milliseconds: 500), () async {
      if (isClosed) return;

      _lastSearchQuery = query.toLowerCase();
      await refresh(); // استخدم refresh بدلاً من _updateStateWithCurrentFilters
    });
  }

  Future<void> updateUserStatus({
    required String userId,
    required bool newStatus,
  }) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      emit(EditUsersLoading());

      final result = await userRepo.updateUserStatus(
        userId: userId,
        newStatus: newStatus,
      );

      if (isClosed) return;

      await result.fold(
        (failure) async {
          emit(EditUsersFailed(errMessage: failure.message));
        },
        (_) async {
          // تحديث المستخدم في القائمة المحلية
          _allUsers =
              _allUsers.map((user) {
                if (user.uId == userId) {
                  return user.copyWith(isActive: newStatus);
                }
                return user;
              }).toList();

          // تحديث الإحصائيات محلياً
          final activeCount = _allUsers.where((user) => user.isActive).length;
          final inactiveCount = _allUsers.length - activeCount;

          emit(EditUsersSuccess());

          // إرسال الحالة المحدثة مباشرة
          emit(
            GetUsersSuccess(
              users: _applyFilters(),
              activeInactive: ActiveInactive(
                active: activeCount,
                inActive: inactiveCount,
              ),
              // isFiltered: _isFiltered,
              // activeFilter: _activeFilter,
              // searchQuery: _lastSearchQuery,
            ),
          );
        },
      );
    } catch (e) {
      if (!isClosed) {
        emit(EditUsersFailed(errMessage: e.toString()));
      }
    } finally {
      _isLoading = false;
    }
  }

  Future<void> deleteUser({required String id}) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      emit(DeleteUsersLoading());

      final result = await userRepo.deleteUser(id: id);

      if (isClosed) return;

      await result.fold(
        (failure) async {
          emit(DeleteUsersError(errMessage: failure.message));
        },
        (_) async {
          // حذف المستخدم من القائمة المحلية
          _allUsers.removeWhere((user) => user.uId == id);

          // تحديث الإحصائيات محلياً
          final activeCount = _allUsers.where((user) => user.isActive).length;
          final inactiveCount = _allUsers.length - activeCount;

          emit(DeleteUsersSuccess());

          // إرسال الحالة المحدثة مباشرة
          emit(
            GetUsersSuccess(
              users: _applyFilters(),
              activeInactive: ActiveInactive(
                active: activeCount,
                inActive: inactiveCount,
              ),
              // isFiltered: _isFiltered,
              // activeFilter: _activeFilter,
              // searchQuery: _lastSearchQuery,
            ),
          );
        },
      );
    } catch (e) {
      if (!isClosed) {
        emit(DeleteUsersError(errMessage: e.toString()));
      }
    } finally {
      _isLoading = false;
    }
  }

  Future<void> filterUsers({bool? status}) async {
    if (_activeFilter == status && _isFiltered == (status != null)) return;

    _isFiltered = status != null;
    _activeFilter = status;

    if (state is GetUsersSuccess) {
      final activeInactive = (state as GetUsersSuccess).activeInactive;
      final filteredUsers = _applyFilters();

      emit(
        GetUsersSuccess(
          users: filteredUsers,
          activeInactive: activeInactive,
          // isFiltered: _isFiltered,
          // activeFilter: _activeFilter,
          // searchQuery: _lastSearchQuery,
        ),
      );
    }
  }

  Future<void> getActiveUsers() async {
    await filterUsers(status: true);
  }

  Future<void> getInactiveUsers() async {
    await filterUsers(status: false);
  }

  Future<void> getAllUsers() async {
    await filterUsers(status: null);
  }

  void clearFilters() {
    _isFiltered = false;
    _activeFilter = null;
    _lastSearchQuery = '';

    if (state is GetUsersSuccess) {
      final activeInactive = (state as GetUsersSuccess).activeInactive;
      emit(
        GetUsersSuccess(
          users: _allUsers,
          activeInactive: activeInactive,
          // isFiltered: false,
          // activeFilter: null,
          // searchQuery: '',
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _searchDebouncer?.cancel();
    _dataSubscription?.cancel();
    return super.close();
  }
}