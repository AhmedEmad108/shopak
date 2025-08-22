import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:shopak/core/utils/backend_endpoint.dart';
import 'package:shopak/features/3-auth/domain/entities/user_entity.dart';
import 'package:shopak/features/3-auth/domain/repos/auth_repo.dart';
part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final AuthRepo authRepo;

  UserCubit(this.authRepo) : super(UserInitial());

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
  }
  String getCurrentUserId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }
}
