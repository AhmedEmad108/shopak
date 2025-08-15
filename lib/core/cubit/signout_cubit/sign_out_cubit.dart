import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shopak/contants.dart';
import 'package:shopak/core/services/shared_prefrences_singletone.dart';
import 'package:shopak/features/3-auth/domain/repos/auth_repo.dart';

part 'sign_out_state.dart';

class SignOutCubit extends Cubit<SignOutState> {
  SignOutCubit(this.authRepo) : super(SignOutInitial());
  final AuthRepo authRepo;

  Future<void> signOut() async {
    emit(SignOutLoading());
    try {
      await authRepo.signOut();
      Prefs.deleteString(
        kUserData,
      );
      emit(SignOutSuccess());
    } catch (e) {
      emit(SignOutError(message: e.toString()));
    }
  }
}
