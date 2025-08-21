import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopak/core/helper_functions/get_user.dart';
import 'package:shopak/features/3-auth/domain/entities/user_entity.dart';
import 'package:shopak/features/3-auth/domain/repos/auth_repo.dart';

part 'edit_email_state.dart';

class EditEmailCubit extends Cubit<EditEmailState> {
  EditEmailCubit(this.authRepo) : super(EditEmailInitial());
  final AuthRepo authRepo;

  Future<void> updateEmail({
    required String newEmail,
    String? currentPassword,
  }) async {
    emit(EditEmailLoading());
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        emit(EditEmailFailed(error: 'User not logged in'));
        return;
      }

      // ReAuth لو محتاج
      if (currentPassword != null && user.email != null) {
        final cred = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(cred);
      }

      // إرسال لينك التحقق
      await user.verifyBeforeUpdateEmail(newEmail);

      emit(const EditEmailSuccess(
        message: 'Verification email sent. Please check your inbox.',
      ));
    } catch (e) {
      emit(EditEmailFailed(error: e.toString()));
    }
  }

  Future<void> checkEmailVerification({required String newEmail}) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload();
        user = FirebaseAuth.instance.currentUser;

        if (user?.email == newEmail) {
          UserEntity currentUser = getUser();

          UserEntity updatedUser = UserEntity(
            uId: currentUser.uId,
            email: newEmail,
            name: currentUser.name,
            phone: currentUser.phone,
            image: currentUser.image,
          );

          await authRepo.updateUserData(user: updatedUser);
          await authRepo.updateUserLocally(user: updatedUser);

          emit(const EditEmailSuccess(
            message: 'Email updated successfully',
          ));
        } else {
          emit(EditEmailFailed(error: 'Email verification still pending'));
        }
      }
    } catch (e) {
      emit(EditEmailFailed(error: e.toString()));
    }
  }
}


// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shopak/core/helper_functions/get_user.dart';
// import 'package:shopak/features/3-auth/domain/entities/user_entity.dart';
// import 'package:shopak/features/3-auth/domain/repos/auth_repo.dart';

// part 'edit_email_state.dart';

// class EditEmailCubit extends Cubit<EditEmailState> {
//   EditEmailCubit(this.authRepo) : super(EditEmailInitial());
//   final AuthRepo authRepo;

//   Future<void> updateEmail({required String newEmail}) async {
//     emit(EditEmailLoading());
//     try {
//       // أولاً: إرسال إيميل التحقق
//       await authRepo.updateUserEmail(newEmail: newEmail);

//       // نراقب حالة التحقق من الإيميل
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         // ننتظر حتى يتم التحقق من الإيميل الجديد
//         await user.reload();
//         user = FirebaseAuth.instance.currentUser; // تحديث بيانات المستخدم

//         // نتحقق إذا تم تغيير الإيميل بنجاح
//         if (user?.email == newEmail) {
//           // الحصول على بيانات المستخدم الحالي
//           UserEntity currentUser = getUser();

//           // تحديث بيانات المستخدم في Firestore
//           UserEntity updatedUser = UserEntity(
//             uId: currentUser.uId,
//             email: newEmail,
//             name: currentUser.name,
//             phone: currentUser.phone,
//             image: currentUser.image,
//             // address: currentUser.address,
//             // createdAt: currentUser.createdAt,
//             // updatedAt: DateTime.now().toIso8601String(),
//             // status: currentUser.status,
//           );

//           // تحديث البيانات في Firestore
//           await authRepo.updateUserData(user: updatedUser);

//           // تحديث البيانات محلياً
//           await authRepo.updateUserLocally(user: updatedUser);

//           emit(EditEmailSuccess());
//         } else {
//           emit(EditEmailFailed(error: 'Email verification pending'));
//         }
//       }
//     } catch (e) {
//       emit(EditEmailFailed(error: e.toString()));
//     }
//   }

//   // إضافة دالة جديدة لمراقبة حالة التحقق
//   Future<void> checkEmailVerification({required String newEmail}) async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         await user.reload();
//         user = FirebaseAuth.instance.currentUser;

//         if (user?.email == newEmail) {
//           // تم التحقق بنجاح، نقوم بتحديث البيانات
//           UserEntity currentUser = getUser();

//           UserEntity updatedUser = UserEntity(
//             uId: currentUser.uId,
//             email: newEmail,
//             name: currentUser.name,
//             phone: currentUser.phone,
//             image: currentUser.image,
//             // address: currentUser.address,
//             // createdAt: currentUser.createdAt,
//             // updatedAt: DateTime.now().toIso8601String(),
//             // status: currentUser.status,
//           );

//           await authRepo.updateUserData(user: updatedUser);
//           await authRepo.updateUserLocally(user: updatedUser);

//           emit(EditEmailSuccess());
//         }
//       }
//     } catch (e) {
//       emit(EditEmailFailed(error: e.toString()));
//     }
//   }
// }
// class EditEmailCubit extends Cubit<EditEmailState> {
//   EditEmailCubit(this.authRepo) : super(EditEmailInitial());
//   final AuthRepo authRepo;

//   Future<void> updateEmail({required String newEmail}) async {
//     emit(EditEmailLoading());
//     try {
//       // تحديث الإيميل في Firebase Auth
//       await authRepo.updateUserEmail(newEmail: newEmail);
      
//       // الحصول على بيانات المستخدم الحالي
//       UserEntity currentUser = getUser();
      
//       // تحديث بيانات المستخدم في Firestore
//       UserEntity updatedUser = UserEntity(
//         uId: currentUser.uId,
//         email: newEmail,  // الإيميل الجديد
//         name: currentUser.name,
//         phone: currentUser.phone,
//         image: currentUser.image,
//         address: currentUser.address,
//         createdAt: currentUser.createdAt,
//         updatedAt: DateTime.now().toIso8601String(),
//         status: currentUser.status,
//       );

//       // تحديث البيانات في Firestore
//       await authRepo.updateUserData(user: updatedUser);
      
//       // تحديث البيانات محلياً
//       await authRepo.updateUserLocally(user: updatedUser);

//       emit(EditEmailSuccess());
//     } catch (e) {
//       emit(EditEmailFailed(error: e.toString()));
//     }
//   }
// }


// class EditEmailCubit extends Cubit<EditEmailState> {
//   EditEmailCubit(this.authRepo) : super(EditEmailInitial());
//   final AuthRepo authRepo;

//   Future<void> updateEmail({required String newEmail}) async {
//     emit(EditEmailLoading());
//     try {
//       await authRepo.updateUserEmail(newEmail: newEmail);
//       emit(EditEmailSuccess());
//     } catch (e) {
//       emit(EditEmailFailed(error: e.toString()));
//     }
//   }
// }
