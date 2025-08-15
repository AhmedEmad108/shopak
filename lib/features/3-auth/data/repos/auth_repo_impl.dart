import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopak/contants.dart';
import 'package:shopak/core/errors/exceptions.dart';
import 'package:shopak/core/errors/failures.dart';
import 'package:shopak/core/services/database_service.dart';
import 'package:shopak/core/services/firebase_auth_service.dart';
import 'package:shopak/core/services/shared_prefrences_singletone.dart';
import 'package:shopak/core/utils/backend_endpoint.dart';
import 'package:shopak/features/3-auth/data/models/user_model.dart';
import 'package:shopak/features/3-auth/domain/entities/user_entity.dart';
import 'package:shopak/features/3-auth/domain/repos/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final FirebaseAuthService firebaseAuthService;
  final DatabaseService databaseService;
  AuthRepoImpl({
    required this.firebaseAuthService,
    required this.databaseService,
  });
  @override
  Future<Either<Failures, UserEntity>> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String image,
  }) async {
    User? user;

    try {
      user = await firebaseAuthService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      var userEntity = UserEntity(
        uId: user.uid,
        email: email,
        name: name,
        phone: phone,
        image: image,
      );
      await user.sendEmailVerification();
      await addUserData(user: userEntity);
      return right(userEntity);
    } on CustomException catch (e) {
      await deleteUser(user);
      return left(ServerFailure(message: e.message));
    } catch (e) {
      await deleteUser(user);
      log('Exception in createUserWithEmailAndPassword: ${e.toString()}');
      return left(
        ServerFailure(message: 'Something went wrong. Please try again later.'),
      );
    }
  }

  Future<void> deleteUser(User? user) async {
    if (user != null) {
      await firebaseAuthService.deleteUser();
    }
  }

  @override
  Future<Either<Failures, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      var user = await firebaseAuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      var userEntity = await getUserData(uId: user.uid);
      await saveUserLocally(user: userEntity);
      return right(userEntity);
    } on CustomException catch (e) {
      return left(ServerFailure(message: e.message));
    } catch (e) {
      log('Exception in signInWithEmailAndPassword: ${e.toString()}');
      return left(
        ServerFailure(message: 'Something went wrong. Please try again later.'),
      );
    }
  }

  @override
  Future addUserData({required UserEntity user}) async {
    await databaseService.addData(
      path: BackendEndpoint.userData,
      data: UserModel.fromEntity(user).toMap(),
      documentId: user.uId,
    );
  }

  @override
  Future getUserData({required String uId}) async {
    try {
      var userData = await databaseService.getData(
        path: BackendEndpoint.userData,
        documentId: uId,
      );
      return UserModel.fromJson(userData);
    } catch (e) {
      log('Exception in getUserData: ${e.toString()}');
      return ServerFailure(message: e.toString());
    }
    // var userData = await databaseService.getData(
    //   path: BackendEndpoint.userData,
    //   documentId: uId,
    // );
    // return UserModel.fromJson(userData);
  }

  @override
  Future<Either<Failures, void>> updateUserData({
    required UserEntity user,
  }) async {
    try {
      await databaseService.updateData(
        path: BackendEndpoint.userData,
        data: UserModel.fromEntity(user).toMap(),
        documentId: user.uId,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failures, void>> updateUserImage({
    required String uId,
    required String image,
  }) async {
    try {
      await databaseService.updateData(
        path: BackendEndpoint.userData,
        data: {'image': image},
        documentId: uId,
      );
      // await updateUserLocally(user: );

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future saveUserLocally({required UserEntity user}) async {
    var jsonData = jsonEncode(UserModel.fromEntity(user).toMap());
    await Prefs.setString(kUserData, jsonData);
  }

  @override
  Future updateUserLocally({required UserEntity user}) async {
    var jsonData = jsonEncode(UserModel.fromEntity(user).toMap());
    await Prefs.setString(kUserData, jsonData);
  }

  @override
  Future deleteUserLocally() async {
    await Prefs.deleteString(kUserData);
  }

  @override
  Future signOut() async {
    await deleteUserLocally();
    await firebaseAuthService.signOut();
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await firebaseAuthService.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  @override
  Future<void> updateUserEmail({required String newEmail}) async {
    await firebaseAuthService.updateEmail(newEmail);
  }
}
