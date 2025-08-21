import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopak/core/services/get_it.dart';
import 'package:shopak/core/widgets/custom_appbar.dart';
import 'package:shopak/features/3-auth/domain/repos/auth_repo.dart';
import 'package:shopak/features/5-profile/presentation/views/edit_email/cubit/edit_email_cubit.dart';
import 'package:shopak/features/5-profile/presentation/views/edit_email/widgets/change_email_view_bloc_consumer.dart';
import 'package:shopak/generated/l10n.dart';

class ChangeEmailView extends StatelessWidget {
  const ChangeEmailView({super.key});
  static const routeName = '/change-email';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditEmailCubit(getIt<AuthRepo>()),
      child: Scaffold(
        appBar: customAppBar(
          context,
          title: S.of(context).change_email,
          icon: true,
        ),
        body: ChangeEmailViewBlocConsumer(),
      ),
    );
  }
}
