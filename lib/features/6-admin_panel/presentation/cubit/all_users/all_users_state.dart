part of 'all_users_cubit.dart';

sealed class AllUsersState extends Equatable {
  const AllUsersState();

  @override
  List<Object> get props => [];
}

final class AllUsersInitial extends AllUsersState {}

//get
final class GetUsersLoading extends AllUsersState {}

final class GetUsersSuccess extends AllUsersState {
  final List<UserEntity>users;
      final ActiveInactive activeInactive;

  const GetUsersSuccess({required this.users, required this.activeInactive});
}

final class GetUsersFailed extends AllUsersState {
  final String error;
  const GetUsersFailed({required this.error});
}

//edit
final class EditUsersLoading extends AllUsersState {}

final class EditUsersFailed extends AllUsersState {
  final String errMessage;
  const EditUsersFailed({required this.errMessage});
}

final class EditUsersSuccess extends AllUsersState {}

//delete
final class DeleteUsersLoading extends AllUsersState {}

final class DeleteUsersSuccess extends AllUsersState {}

final class DeleteUsersError extends AllUsersState {
  final String errMessage;
  const DeleteUsersError({required this.errMessage});
}

// إضافة الحالات الجديدة للفلترة وتحديث الحالة

// حالات تحديث حالة المنتج
final class UpdateUsersStatusLoading extends AllUsersState {}

final class UpdateUsersStatusSuccess extends AllUsersState {}

final class UpdateUsersStatusFailure extends AllUsersState {
  final String error;
  const UpdateUsersStatusFailure(this.error);
}

// حالات البحث
final class SearchUsersLoading extends AllUsersState {}

final class SearchUsersSuccess extends AllUsersState {
  final List<UserEntity>users;
  const SearchUsersSuccess({required this.users});
}

final class SearchUsersError extends AllUsersState {
  final String error;
  const SearchUsersError({required this.error});
}

// حالات الفلترة
final class FilterUsersLoading extends AllUsersState {}

final class FilterUsersSuccess extends AllUsersState {
  final List<UserEntity>users;
  const FilterUsersSuccess({required this.users});
}

final class FilterUsersError extends AllUsersState {
  final String error;
  const FilterUsersError({required this.error});
}

// حالات تحديث البيانات في الخلفية
final class BackgroundUpdateLoading extends AllUsersState {}

final class BackgroundUpdateSuccess extends AllUsersState {
  final List<UserEntity>users;
  const BackgroundUpdateSuccess({required this.users});
}

final class BackgroundUpdateError extends AllUsersState {
  final String error;
  const BackgroundUpdateError({required this.error});
}


