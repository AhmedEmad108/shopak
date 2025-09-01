import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopak/core/helper_functions/get_dummy.dart';
import 'package:shopak/core/widgets/custom_snack_bar.dart';
import 'package:shopak/core/widgets/empty_widget.dart';
import 'package:shopak/features/6-admin_panel/presentation/cubit/all_users/all_users_cubit.dart';
import 'package:shopak/features/6-admin_panel/presentation/views/widgets/manage_users/widgets/manage_users_view_body.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ManageUserBlocConsumer extends StatefulWidget {
  const ManageUserBlocConsumer({super.key});

  @override
  State<ManageUserBlocConsumer> createState() => _ManageUserBlocConsumerState();
}

class _ManageUserBlocConsumerState extends State<ManageUserBlocConsumer> {
  @override
  void initState() {
    loadInitialData();
    super.initState();
  }

  Future<void> loadInitialData() async {
    // استدعاء واحد فقط للبيانات
    await context.read<AllUsersCubit>().getActiveUsers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AllUsersCubit, AllUsersState>(
      listenWhen: (previous, current) {
        // إعادة بناء الواجهة عند تغير الحالة أو البيانات
        return previous.runtimeType != current.runtimeType ||
            (current is GetUsersSuccess &&
                previous is GetUsersSuccess &&
                current.users != previous.users);
      },
      // buildWhen: (previous, current) {
      //   // تجنب إعادة البناء غير الضرورية
      //   return previous.runtimeType != current.runtimeType ||
      //       (current is GetUsersSuccess &&
      //           previous is GetUsersSuccess &&
      //           current.users != previous.users);
      // },
      listener: (context, state) {
        if (state is GetUsersFailed) {
          customSnackBar(context, message: state.error);
        } else if (state is EditUsersSuccess) {
          customSnackBar(context, message: 'Updated Successfully');
        } else if (state is EditUsersFailed) {
          customSnackBar(context, message: state.errMessage);
        } else if (state is DeleteUsersSuccess) {
          customSnackBar(context, message: 'Deleted Successfully');
          Navigator.pop(context);
        } else if (state is DeleteUsersError) {
          customSnackBar(context, message: state.errMessage);
        }
      },
      builder: (context, state) {
        if (state is GetUsersLoading) {
          return Skeletonizer(
            enabled: true,
            child: ManageUsersViewBody(
              users: getDummyUsers(),
              activeCount: 0,
              inactiveCount: 0,
              view: false,
            ),
          );
        } else if (state is GetUsersFailed) {
          return ErrorHandlingWidget(
            error: state.error,
            onRetry: () {
              context.read<AllUsersCubit>().getActiveUsers();
            },
          );
        } else if (state is GetUsersSuccess) {
          return ManageUsersViewBody(
            users: state.users,
            activeCount: state.activeInactive.active,
            inactiveCount: state.activeInactive.inActive,
          );
        } else {
          return Skeletonizer(
            enabled: true,
            child: ManageUsersViewBody(
              users: getDummyUsers(),
              activeCount: 0,
              inactiveCount: 0,
              view: false,
            ),
          );
          // return const SizedBox.shrink();
        }
      },
    );
  }
}
