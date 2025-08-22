import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:shopak/core/helper_functions/get_user.dart';
import 'package:shopak/core/utils/backend_endpoint.dart';
import 'package:shopak/features/3-auth/domain/entities/user_entity.dart';
import 'package:shopak/features/3-auth/domain/repos/auth_repo.dart';
// import 'package:shopak/core/helper_functions/get_user.dart';
// import 'package:shopak/features/3-auth/domain/entities/user_entity.dart';
// import 'package:shopak/features/3-auth/domain/repos/auth_repo.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final AuthRepo authRepo;

  UserCubit(this.authRepo) : super(UserInitial()) {
    // getUserData();
  }
  // UserEntity user = getUser();

  final firebaseAuth = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  Stream<DocumentSnapshot<Map<String, dynamic>>>? userStream;

  void listenToUserData() {
    emit(GetUserLoading());
    final currentUser = auth.currentUser;
    if (currentUser == null) {
      emit(GetUserFailed(errMessage: 'No user is currently logged in.'));
      return;
    }
    userStream =
        firebaseAuth
            .collection(BackendEndpoint.userData)
            .doc(currentUser.uid)
            .snapshots();

    userStream!.listen(
      (snapshot) async {
        if (snapshot.exists && snapshot.data() != null) {
          final user = UserEntity.fromMap(snapshot.data()!);
          await authRepo.updateUserLocally(user: user);
          emit(GetUserSuccess(user: user));
        } else {
          emit(GetUserFailed(errMessage: 'User data does not exist.'));
        }
      },
      onError: (error) {
        emit(GetUserFailed(errMessage: error.toString()));
      },
    );
  }

  User? user;

  Future<void> getUserData() async {
    emit(GetUserLoading());

    final result = await authRepo.getUserData(uId: getCurrentUserId());
    result.fold((l) => emit(GetUserFailed(errMessage: l.message)), (r) async {
      emit(GetUserSuccess(user: r));
      await authRepo.saveUserLocally(user: r);
    });
    // try {
    //   final reselt = await authRepo.getUserData(uId: getCurrentUserId());
    //   emit(GetUserSuccess(user: reselt));
    //   await authRepo.saveUserLocally(
    //     user: UserEntity(
    //       uId: reselt.uId,
    //       email: reselt.email,
    //       name: reselt.name,
    //       phone: reselt.phone,
    //       image: reselt.image,
    //       address: reselt.address,
    //       isActive: reselt.isActive,
    //       isEmailVerified: reselt.isEmailVerified,
    //       role: reselt.role,
    //       createdAt: reselt.createdAt,
    //       updatedAt: reselt.updatedAt,
    //       lastLogin: reselt.lastLogin,
    //     ),
    //   );
    // } catch (e) {
    //   emit(GetUserFailed(errMessage: e.toString()));
    // }
  }

  Future<void> signOut() async {
    await authRepo.signOut();
    emit(UserInitial());
  }

  Future<void> editUserImage({required String image}) async {
    try {
      emit(GetUserLoading());
      await authRepo.updateUserImage(uId: getCurrentUserId(), image: image);
      await getUserData();
    } catch (e) {
      emit(GetUserFailed(errMessage: e.toString()));
    }
  }

  Future<void> editUser({required UserEntity user}) async {
    emit(EditUserLoading());
    try {
      await authRepo.updateUserData(user: user);
      emit(EditUserSuccess());
      await getUserData();
    } catch (e) {
      emit(EditUserFailed(errMessage: e.toString()));
    }
    // result.fold(
    //   (l) => emit(EditUserFailed(
    //     errMessage: l.message,
    //   )),
    //   (r) => emit(
    //     EditUserSuccess(
    //       user: user,
    //     ),
    //     await getUserData(),
    //   ),
    // );
  }

  Future<void> updateEmail({required String newEmail}) async {
    emit(ChangeEmailLoading());
    try {
      // ✉️ بعت لينك Verify على الإيميل الجديد
      await FirebaseAuth.instance.currentUser!.verifyBeforeUpdateEmail(
        newEmail,
      );

      // 👂 نسمع على تغييرات المستخدم
      FirebaseAuth.instance.userChanges().listen((user) async {
        if (user != null && user.email == newEmail && user.emailVerified) {
          // ✅ المستخدم اتحقق والإيميل اتغير في Firebase Auth

          UserEntity currentUser = getUser();

          UserEntity updatedUser = currentUser.copyWith(
            email: newEmail,
            isEmailVerified: true,
            updatedAt: DateTime.now(),
          );

          // 🔥 تحديث Firestore
          await authRepo.updateUserData(user: updatedUser);

          // 💾 تحديث التخزين المحلي
          await authRepo.updateUserLocally(user: updatedUser);

          emit(ChangeEmailSuccess());
        }
      });
    } catch (e) {
      emit(ChangeEmailFailed(error: e.toString()));
    }
  }

  String getCurrentUserId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }
}
