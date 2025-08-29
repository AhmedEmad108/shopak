import 'package:dartz/dartz.dart';
import 'package:shopak/core/errors/failures.dart';
import 'package:shopak/features/3-auth/domain/entities/user_entity.dart';
import 'package:shopak/features/6-admin_panel/data/repos/users_repo_impl.dart';

abstract class UsersRepo {
  Future<Either<Failures, List<UserEntity>>> getUser({bool? status});
  Future<Either<Failures, void>> updateUser(
      {required UserEntity userEntity});
  Future<Either<Failures, void>> deleteUser({required String id});

  Future<Either<Failures, void>> updateUserStatus({
    required String userId,
    required bool newStatus,
  });
  Future<Either<Failures, ActiveInactive>> getUserStats();

  Future<Either<Failures, List<UserEntity>>> searchUsers(String query,
      {bool? status});

  Stream<List<UserEntity>> getUsersStream({bool? activeOnly});



  // Future<Either<Failures, void>> addProduct(
  //     {required ProductEntity addProductInputEntity});
  // Future<Either<Failures, List<ProductEntity>>> getProduct({bool? status});
  // Future<Either<Failures, void>> updateProduct(
  //     {required ProductEntity product});
  // Future<Either<Failures, void>> deleteProduct({required String id});

  //  Future<Either<Failures, void>> updateProductStatus({
  //   required String productId,
  //   required bool newStatus,
  // });


  // Future<Either<Failures, ActiveInactive>> getProductStats();

  // Future<Either<Failures, List<ProductEntity>>> searchProduct(String query,
  //     {bool? status});

  // Stream<List<ProductEntity>> getProductStream({bool? activeOnly});



  

}
