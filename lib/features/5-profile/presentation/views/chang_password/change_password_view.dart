import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopak/core/widgets/custom_appbar.dart';
import 'package:shopak/core/cubit/change_password/change_password_cubit.dart';
import 'package:shopak/core/services/get_it.dart';
import 'package:shopak/features/3-auth/domain/repos/auth_repo.dart';
import 'package:shopak/features/5-profile/presentation/views/chang_password/widgets/change_password_view_body_bloc_consumer.dart';
import 'package:shopak/generated/l10n.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});
  static const routeName = '/changePassword';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context,
        title: S.of(context).change_password,
        icon: true,
      ),
      body: BlocProvider(
        create: (context) => ChangePasswordCubit(getIt<AuthRepo>()),
        child: ChangePasswordViewBodyBlocConsumer(),
      ),
    );
  }
}
