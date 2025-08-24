import 'package:dartz/dartz.dart';
import 'package:shopak/core/errors/failures.dart';
import 'package:shopak/features/3-auth/domain/entities/user_entity.dart';

abstract class AuthRepo {
  Future<Either<Failures, UserEntity>> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String image,
  });

  Future<Either<Failures, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failures, Unit>> addUserData({required UserEntity user});
  Future<Either<Failures, UserEntity>> getUserData({required String uId});
  Future<Either<Failures, Unit>> updateUserData({required UserEntity user});
  Future<Either<Failures, Unit>> updateUserImage({
    required String uId,
    required String image,
  });
  Future<Either<Failures, Unit>> saveUserLocally({required UserEntity user});
  Future<Either<Failures, Unit>> updateUserLocally({required UserEntity user});
  Future<Either<Failures, Unit>> deleteUserLocally();
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<Either<Failures, Unit>> resetPassword({required String email});

  Future<Either<Failures, Unit>> updateUserEmail({required String newEmail});

  Future<Either<Failures, Unit>> signOut();
}
