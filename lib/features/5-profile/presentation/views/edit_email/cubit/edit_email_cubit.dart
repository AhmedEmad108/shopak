import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

      // لو محتاج ReAuth
      if (currentPassword != null && user.email != null) {
        final cred = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(cred);
      }

      // إرسال لينك التحقق
      await user.verifyBeforeUpdateEmail(newEmail);

      emit(
        const EditEmailSuccess(
          message: 'Verification email sent. Please check your inbox.',
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        emit(
          EditEmailFailed(error: 'Please reauthenticate to change your email.'),
        );
      } else if (e.code == 'firebase_auth/requires-recent-login') {
        emit(
          EditEmailFailed(error: 'Please reauthenticate to change your email.'),
        );
      } else {
        emit(
          EditEmailFailed(
            error: e.message ?? 'An error occurred while updating email.',
          ),
        );
      }
    } catch (e) {
      emit(EditEmailFailed(error: e.toString()));
    }
  }
}