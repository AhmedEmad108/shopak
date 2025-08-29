import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopak/core/helper_functions/get_dummy.dart';
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
    return BlocBuilder<AllUsersCubit, AllUsersState>(
      // buildWhen: (previous, current) {
      //   // تجنب إعادة البناء غير الضرورية
      //   return previous.runtimeType != current.runtimeType ||
      //       (current is GetUserSuccess &&
      //           previous is GetUserSuccess &&
      //           current.users != previous.users);
      // },
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
          // if (state.Users.isEmpty) {
          //   return Center(
          //     child: Text(
          //       S.of(context).no_Users_found,
          //       style: Theme.of(context).textTheme.titleLarge,
          //     ),
          //   );
          // }
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
          return const SizedBox.shrink();
        }
      },
    );
  }
}
