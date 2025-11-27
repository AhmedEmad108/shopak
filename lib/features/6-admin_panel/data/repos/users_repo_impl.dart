import 'package:dartz/dartz.dart';
import 'package:shopak/core/errors/failures.dart';
import 'package:shopak/core/services/database_service.dart';
import 'package:shopak/core/services/firestore_service.dart';
import 'package:shopak/core/utils/backend_endpoint.dart';
import 'package:shopak/features/3-auth/data/models/user_model.dart';
import 'package:shopak/features/3-auth/domain/entities/user_entity.dart';
import 'package:shopak/features/6-admin_panel/domain/repos/users_repo.dart';

class UsersRepoImpl implements UsersRepo {
  final DatabaseService databaseService;

  UsersRepoImpl({required this.databaseService});

  @override
  Future<Either<Failures, List<UserEntity>>> getUser({bool? status}) async {
    try {
      Map<String, dynamic>? query;
      if (status != null) {
        query = {'isActive': status};
      }
      var data =
          await databaseService.getData(
                path: BackendEndpoint.userData,
                query: query,
              )
              as List<Map<String, dynamic>>;
      List<UserModel> users = data.map((e) => UserModel.fromJson(e)).toList();
      List<UserEntity> user = users.map((e) => e.toEntity()).toList();
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failures, void>> deleteUser({required String uId}) async {
    try {
      await databaseService.deleteData(
        path: BackendEndpoint.userData,
        documentId: uId,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failures, void>> updateUser({
    required UserEntity user,
  }) async {
    try {
      await databaseService.updateData(
        path: BackendEndpoint.userData,
        data: UserModel.fromEntity(user).toJson(),
        documentId: user.uId,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failures, void>> updateUserStatus({
    required String uId,
    required bool status,
  }) async {
    try {
      await databaseService.updateData(
        path: BackendEndpoint.userData,
        documentId: uId,
        data: {'isActive': status},
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failures, ActiveInactive>> getUserStats() async {
    try {
      // جلب كل الفئات
      var data =
          await databaseService.getData(path: BackendEndpoint.userData)
              as List<Map<String, dynamic>>;

      // حساب عدد الفئات النشطة وغير النشطة
      int activeCount = 0;
      int inactiveCount = 0;

      activeCount = data.where((element) => element['isActive'] == true).length;
      inactiveCount =
          data.where((element) => element['isActive'] == false).length;

      return Right(
        ActiveInactive(active: activeCount, inActive: inactiveCount),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failures, List<UserEntity>>> searchUsers(
    String query, {
    bool? status,
  }) async {
    try {
      var data =
          await databaseService.getData(path: BackendEndpoint.userData)
              as List<Map<String, dynamic>>;
      List<UserModel> users =
          data
              .map((e) => UserModel.fromJson(e))
              .where(
                (user) =>
                    user.name.toLowerCase().contains(query.toLowerCase()) ||
                    user.email.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
      List<UserEntity> userEntity = users.map((e) => e.toEntity()).toList();

      return Right(userEntity);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Stream<List<UserEntity>> getUsersStream({bool? activeOnly}) {
    Map<String, dynamic>? query;
    if (activeOnly != null) {
      query = {'isActive': activeOnly};
    }

    return (databaseService as FirestoreService)
        .getDataStream(path: BackendEndpoint.userData, query: query)
        .map(
          (data) =>
              data
                  .map((json) => UserModel.fromJson(json))
                  .map((model) => model.toEntity())
                  .toList(),
        );
  }
}

class ActiveInactive {
  final int active;
  final int inActive;

  ActiveInactive({required this.active, required this.inActive});
}
