import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopak/core/services/get_it.dart';
import 'package:shopak/core/widgets/custom_appbar.dart';
import 'package:shopak/features/3-auth/domain/entities/user_entity.dart';
import 'package:shopak/features/6-admin_panel/domain/repos/users_repo.dart';
import 'package:shopak/features/6-admin_panel/presentation/cubit/all_users/all_users_cubit.dart';
import 'package:shopak/features/6-admin_panel/presentation/views/widgets/manage_users/widgets/details_user_view_body.dart';
import 'package:shopak/generated/l10n.dart';

class DetailsUserView extends StatelessWidget {
  const DetailsUserView({super.key, required this.user});
  static const String routeName = '/details_user';
  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context,
        title: '${S.of(context).detail} ${user.name}',
        icon: true,
      ),
      body: DetailsUserViewBody(user: user),
    );
  }
}
