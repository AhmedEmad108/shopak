// part of 'all_users_cubit.dart';

// abstract class AllUsersState extends Equatable {
//   const AllUsersState();

//   @override
//   List<Object?> get props => [];
// }

// class AllUsersInitial extends AllUsersState {}

// class GetUsersLoading extends AllUsersState {}

// class GetUsersSuccess extends AllUsersState {
//   final List<UserEntity> users;
//   final ActiveInactive activeInactive;

//   const GetUsersSuccess({
//     required this.users,
//     required this.activeInactive,
//   });

//   @override
//   List<Object?> get props => [users, activeInactive];
// }

// class GetUsersFailed extends AllUsersState {
//   final String error;

//   const GetUsersFailed({required this.error});

//   @override
//   List<Object?> get props => [error];
// }

// /// تحديث الحالة
// class UpdateUsersStatusLoading extends AllUsersState {}

// class UpdateUsersStatusSuccess extends AllUsersState {}

// class UpdateUsersStatusFailed extends AllUsersState {
//   final String error;
//   const UpdateUsersStatusFailed({required this.error});
//   @override
//   List<Object?> get props => [error];
// }

// /// تعديل بيانات
// class EditUsersLoading extends AllUsersState {}

// class EditUsersSuccess extends AllUsersState {}

// class EditUsersFailed extends AllUsersState {
//   final String error;
//   const EditUsersFailed({required this.error});
//   @override
//   List<Object?> get props => [error];
// }

// /// حذف
// class DeleteUsersLoading extends AllUsersState {}

// class DeleteUsersSuccess extends AllUsersState {}

// class DeleteUsersFailed extends AllUsersState {
//   final String error;
//   const DeleteUsersFailed({required this.error});
//   @override
//   List<Object?> get props => [error];
// }

// /// إحصائيات Active / Inactive
// class ActiveInactive extends Equatable {
//   final int active;
//   final int inActive;

//   const ActiveInactive({
//     required this.active,
//     required this.inActive,
//   });

//   @override
//   List<Object?> get props => [active, inActive];
// }


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
  final String error;
  const EditUsersFailed({required this.error});
}

final class EditUsersSuccess extends AllUsersState {}

//delete
final class DeleteUsersLoading extends AllUsersState {}

final class DeleteUsersSuccess extends AllUsersState {}

final class DeleteUsersFailed extends AllUsersState {
  final String error;
  const DeleteUsersFailed({required this.error});
}

// إضافة الحالات الجديدة للفلترة وتحديث الحالة

// حالات تحديث حالة المنتج
final class UpdateUsersStatusLoading extends AllUsersState {}

final class UpdateUsersStatusSuccess extends AllUsersState {}

final class UpdateUsersStatusFailed extends AllUsersState {
  final String error;
  const UpdateUsersStatusFailed(this.error);
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


