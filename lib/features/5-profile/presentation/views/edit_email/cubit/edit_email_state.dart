part of 'edit_email_cubit.dart';

sealed class EditEmailState extends Equatable {
  const EditEmailState();

  @override
  List<Object> get props => [];
}

final class EditEmailInitial extends EditEmailState {}

final class EditEmailLoading extends EditEmailState {}

final class EditEmailSuccess extends EditEmailState {
  final String message;

  const EditEmailSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

final class EditEmailFailed extends EditEmailState {
  final String error;

  const EditEmailFailed({required this.error});

  @override
  List<Object> get props => [error];
}


// part of 'edit_email_cubit.dart';

// sealed class EditEmailState extends Equatable {
//   const EditEmailState();

//   @override
//   List<Object> get props => [];
// }

// final class EditEmailInitial extends EditEmailState {}

// final class EditEmailLoading extends EditEmailState {}

// final class EditEmailSuccess extends EditEmailState {}

// final class EditEmailFailed extends EditEmailState {
//   final String error;

//   const EditEmailFailed({required this.error});

//   @override
//   List<Object> get props => [error];
// }
