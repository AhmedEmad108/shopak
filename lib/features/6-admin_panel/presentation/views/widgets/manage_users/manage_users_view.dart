import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopak/core/services/get_it.dart';
import 'package:shopak/core/widgets/custom_appbar.dart';
import 'package:shopak/features/6-admin_panel/domain/repos/users_repo.dart';
import 'package:shopak/features/6-admin_panel/presentation/cubit/all_users/all_users_cubit.dart';
import 'package:shopak/features/6-admin_panel/presentation/views/widgets/manage_users/widgets/manage_users_bloc_consumer.dart';
import 'package:shopak/generated/l10n.dart';

class ManageUsersView extends StatefulWidget {
  const ManageUsersView({super.key});
  static const String routeName = '/manage-users';

  @override
  State<ManageUsersView> createState() => _ManageUsersViewState();
}

class _ManageUsersViewState extends State<ManageUsersView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllUsersCubit(getIt.get<UsersRepo>()),
      child: Scaffold(
        appBar: customAppBar(
          context,
          title: S.of(context).manage_users,
          icon: true,
        ),
        body: ManageUserBlocConsumer(),
      ),
    );
  }
}
