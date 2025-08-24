import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopak/features/3-auth/domain/repos/auth_repo.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(this.authRepo) : super(ResetPasswordCubitInitial());
  final AuthRepo authRepo;

  void resetPassword({required String email}) {
    emit(ResetPasswordLoading());

    try {
      final result = authRepo.resetPassword(email: email);
      emit(ResetPasswordSuccess());
    } catch (e) {
      emit(ResetPasswordError(message: e.toString()));
    }
  }
}
