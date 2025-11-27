// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:equatable/equatable.dart';
// import 'package:shopak/core/utils/backend_endpoint.dart';
// import 'package:shopak/features/3-auth/domain/entities/user_entity.dart';

// part 'all_users_state.dart';

// class AllUsersCubit extends Cubit<AllUsersState> {
//   AllUsersCubit() : super(AllUsersInitial()) {
//     _startListeningToDataChanges();
//   }

//   StreamSubscription? _dataSubscription;
//   String _lastSearchQuery = '';
//   bool _isFiltered = false;
//   Map<String, dynamic> _lastFilter = {};
//   List<UserEntity> allUsers = [];

//   void _startListeningToDataChanges() {
//     emit(GetUsersLoading()); // أول ما يبدأ نستعرض لودينج

//     _dataSubscription = FirebaseFirestore.instance
//         .collection(BackendEndpoint.userData)
//         .snapshots()
//         .listen((snapshot) {
//       try {
//         final users = snapshot.docs.map((doc) {
//           return UserEntity.fromMap(doc.data());
//         }).toList();

//         allUsers = users;
//         _applyFilters(); // نطبق الفلاتر والبحث
//       } catch (e) {
//         emit(GetUsersFailed(error: e.toString()));
//       }
//     }, onError: (error) {
//       emit(GetUsersFailed(error: error.toString()));
//     });
//   }

//   // ================== البحث والفلاتر ==================
//   Future<void> filterUsers({bool? status}) async {
//     _isFiltered = status != null;
//     _lastFilter = {'isActive': status};
//     _applyFilters();
//   }

//   Future<void> searchUsers(String query) async {
//     _lastSearchQuery = query.trim().toLowerCase();
//     _applyFilters();
//   }

//   void _applyFilters() {
//     List<UserEntity> filteredUsers = allUsers;

//     if (_isFiltered) {
//       filteredUsers =
//           filteredUsers.where((u) => u.isActive == _lastFilter['isActive']).toList();
//     }

//     if (_lastSearchQuery.isNotEmpty) {
//       filteredUsers = filteredUsers.where((user) {
//         return user.name.toLowerCase().contains(_lastSearchQuery) ||
//             user.email.toLowerCase().contains(_lastSearchQuery);
//       }).toList();
//     }

//     final activeCount = allUsers.where((u) => u.isActive).length;
//     final inactiveCount = allUsers.length - activeCount;

//     emit(GetUsersSuccess(
//       users: filteredUsers,
//       activeInactive: ActiveInactive(
//         active: activeCount,
//         inActive: inactiveCount,
//       ),
//     ));
//   }

//   // ================== تحديث الحالة ==================
//   Future<void> updateUserStatus({
//     required String uId,
//     required bool status,
//   }) async {
//     emit(UpdateUsersStatusLoading());
//     try {
//       await FirebaseFirestore.instance
//           .collection(BackendEndpoint.userData)
//           .doc(uId)
//           .update({'isActive': status});

//       emit(UpdateUsersStatusSuccess());
//       // snapshot هيتكفل بالتحديث أوتوماتيك
//     } catch (e) {
//       emit(UpdateUsersStatusFailed(error: e.toString()));
//     }
//   }

//   // ================== تعديل بيانات ==================
//   Future<void> editUserData(UserEntity user) async {
//     emit(EditUsersLoading());
//     try {
//       await FirebaseFirestore.instance
//           .collection(BackendEndpoint.userData)
//           .doc(user.uId)
//           .update(user.toMap());

//       emit(EditUsersSuccess());
//       // snapshot هيتكفل بالتحديث
//     } catch (e) {
//       emit(EditUsersFailed(error: e.toString()));
//     }
//   }

//   // ================== حذف مستخدم ==================
//   Future<void> deleteUser(String userId) async {
//     emit(DeleteUsersLoading());
//     try {
//       await FirebaseFirestore.instance
//           .collection(BackendEndpoint.userData)
//           .doc(userId)
//           .delete();

//       emit(DeleteUsersSuccess());
//       // snapshot هيتكفل بالتحديث
//     } catch (e) {
//       emit(DeleteUsersFailed(error: e.toString()));
//     }
//   }

//   @override
//   Future<void> close() async {
//     await _dataSubscription?.cancel();
//     return super.close();
//   }
// }

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

  // void _startListeningToDataChanges() {
  //   _dataSubscription = FirebaseFirestore.instance
  //       .collection(BackendEndpoint.userData)
  //       .snapshots()
  //       .listen((snapshot) {
  //         if (!_isLoading && !isUpdating) {
  //           _refreshDataWithCurrentFilter();
  //         }
  //       });
  // }
  void _startListeningToDataChanges() {
    emit(GetUsersLoading()); // أول ما يبدأ نستعرض لودينج

    _dataSubscription = FirebaseFirestore.instance
        .collection(BackendEndpoint.userData)
        .snapshots()
        .listen(
          (snapshot) {
            try {
              final users =
                  snapshot.docs.map((doc) {
                    return UserEntity.fromMap(doc.data());
                  }).toList();

              allUsers = users;
              filterUsers(
                status: _isFiltered ? _lastFilter['isActive'] : null,
              ); // نطبق الفلاتر والبحث
            } catch (e) {
              emit(GetUsersFailed(error: e.toString()));
            }
          },
          onError: (error) {
            emit(GetUsersFailed(error: error.toString()));
          },
        );
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

  void _applyFilters() {
    List<UserEntity> filteredUsers = allUsers;

    if (_isFiltered) {
      filteredUsers =
          filteredUsers
              .where((u) => u.isActive == _lastFilter['isActive'])
              .toList();
    }

    if (_lastSearchQuery.isNotEmpty) {
      filteredUsers =
          filteredUsers.where((user) {
            return user.name.toLowerCase().contains(_lastSearchQuery) ||
                user.email.toLowerCase().contains(_lastSearchQuery);
          }).toList();
    }

    final activeCount = allUsers.where((u) => u.isActive).length;
    final inactiveCount = allUsers.length - activeCount;

    emit(
      GetUsersSuccess(
        users: filteredUsers,
        activeInactive: ActiveInactive(
          active: activeCount,
          inActive: inactiveCount,
        ),
      ),
    );
  }

  Future<void> updateUserStatus({
    required String uId,
    required bool status,
  }) async {
    if (_isLoading) return;

    try {
      _isLoading = true;

      ///
      emit(UpdateUsersStatusLoading());

      final result = await userRepo.updateUserStatus(uId: uId, status: status);

      if (isClosed) return;
      result.fold((failure) => emit(UpdateUsersStatusFailed(failure.message)), (
        _,
      ) async {
        // تحديث المستخدم في القائمة المحلية
        allUsers =
            allUsers.map((user) {
              if (user.uId == uId) {
                return user.copyWith(isActive: status);
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
      });

      // emit(UpdateUsersStatusSuccess());
      // await refresh();
    } catch (e) {
      if (!isClosed) {
        emit(UpdateUsersStatusFailed(e.toString()));
      }
    } finally {
      _isLoading = false;
    }
  }

  Future<void> filterUsers({bool? status}) async {
    _isFiltered = status != null;
    _lastFilter = {'isActive': status};
    // _applyFilters();
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
    var result = await userRepo.updateUser(user: userEntity);
    result.fold(
      (failure) {
        emit(EditUsersFailed(error: failure.message));
      },
      (_) {
        emit(EditUsersSuccess());
        refresh();
      },
    );
  }

  Future<void> deleteUser({required String id}) async {
    emit(DeleteUsersLoading());
    var result = await userRepo.deleteUser(uId: id);
    result.fold(
      (failure) {
        emit(DeleteUsersFailed(error: failure.message));
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
