part of 'reset_password_cubit.dart';

sealed class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object> get props => [];
}

final class ResetPasswordCubitInitial extends ResetPasswordState {}

final class ResetPasswordLoading extends ResetPasswordState {}

final class ResetPasswordError extends ResetPasswordState {
  final String message;
  const ResetPasswordError({required this.message});
}

final class ResetPasswordSuccess extends ResetPasswordState {}
