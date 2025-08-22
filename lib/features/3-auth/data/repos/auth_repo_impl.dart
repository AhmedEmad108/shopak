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

      var userModel = UserModel.fromFirebaseUser(
        user,
      ).copyWith(name: name, phone: phone, image: image);
      await user.sendEmailVerification();
      await addUserData(user: userModel);
      return right(userModel);
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
      await user.reload();
      user = FirebaseAuth.instance.currentUser!;
      var result = await getUserData(uId: user.uid);

      return result.fold((failure) => left(failure), (userEntity) async {
        if (user.emailVerified) {
          if (userEntity.isActive) {
            userEntity = userEntity.copyWith(
              lastLogin: DateTime.now(),
              email: email,
              isEmailVerified: true,
            );
            await updateUserData(user: userEntity);
            await updateUserLocally(user: userEntity);
            return right(userEntity);
          } else {
            return left(
              ServerFailure(
                message: 'Your account is deactivated. Please contact support.',
              ),
            );
          }
        } else {
          await user.sendEmailVerification();
          log('Email not verified');
          return left(
            ServerFailure(
              message:
                  'Email not verified. A verification link has been sent to your email.',
            ),
          );
        }
      });
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
  Future<Either<Failures, Unit>> addUserData({required UserEntity user}) async {
    try {
      await databaseService.addData(
        path: BackendEndpoint.userData,
        data: UserModel.fromEntity(user).toMap(),
        documentId: user.uId,
      );

      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failures, UserEntity>> getUserData({
    required String uId,
  }) async {
    try {
      var userData = await databaseService.getData(
        path: BackendEndpoint.userData,
        documentId: uId,
      );
      return Right(UserModel.fromJson(userData));
    } catch (e) {
      log('Exception in getUserData: ${e.toString()}');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failures, Unit>> updateUserData({
    required UserEntity user,
  }) async {
    try {
      await databaseService.updateData(
        path: BackendEndpoint.userData,
        data: UserModel.fromEntity(user).toMap(),
        documentId: user.uId,
      );
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failures, Unit>> updateUserImage({
    required String uId,
    required String image,
  }) async {
    try {
      await databaseService.updateData(
        path: BackendEndpoint.userData,
        data: {'image': image, 'updatedAt': DateTime.now()},
        documentId: uId,
      );
      // await updateUserLocally(user: );

      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failures, Unit>> saveUserLocally({
    required UserEntity user,
  }) async {
    try {
      var jsonData = jsonEncode(UserModel.fromEntity(user).toMap());
      await Prefs.setString(kUserData, jsonData);
      return const Right(unit);
    } catch (e) {
      log('Exception in saveUserLocally: ${e.toString()}');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failures, Unit>> updateUserLocally({
    required UserEntity user,
  }) async {
    try {
      var jsonData = jsonEncode(UserModel.fromEntity(user).toMap());
      await Prefs.setString(kUserData, jsonData);
      return const Right(unit);
    } catch (e) {
      log('Exception in updateUserLocally: ${e.toString()}');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failures, Unit>> deleteUserLocally() async {
    try {
      await Prefs.deleteString(kUserData);
      return const Right(unit);
    } catch (e) {
      log('Exception in deleteUserLocally: ${e.toString()}');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failures, Unit>> signOut() async {
    try {
      await deleteUserLocally();
      await firebaseAuthService.signOut();
      return const Right(unit);
    } catch (e) {
      log('Exception in signOut: ${e.toString()}');
      return Left(ServerFailure(message: e.toString()));
    }
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
  Future<Either<Failures, Unit>> updateUserEmail({
    required String newEmail,
  }) async {
    try {
      await firebaseAuthService.updateEmail(newEmail);

      return const Right(unit);
    } catch (e) {
      log('Exception in updateUserEmail: ${e.toString()}');
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
