import 'package:get_it/get_it.dart';
import 'package:shopak/core/services/database_service.dart';
import 'package:shopak/core/services/fire_storage.dart';
import 'package:shopak/core/services/firebase_auth_service.dart';
import 'package:shopak/core/services/firestore_service.dart';
import 'package:shopak/core/services/storage_service.dart';
import 'package:shopak/features/3-auth/data/repos/auth_repo_impl.dart';
import 'package:shopak/features/3-auth/domain/repos/auth_repo.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  getIt.registerSingleton<StorageService>(FireStorage());
  getIt.registerSingleton<DatabaseService>(FirestoreService());
  getIt.registerSingleton<AuthRepo>(
    AuthRepoImpl(
      firebaseAuthService: getIt<FirebaseAuthService>(),
      databaseService: getIt<DatabaseService>(),
    ),
  );
}
