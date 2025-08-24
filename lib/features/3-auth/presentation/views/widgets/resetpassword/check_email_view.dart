import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopak/core/services/get_it.dart';
import 'package:shopak/core/widgets/custom_appbar.dart';
import 'package:shopak/features/3-auth/domain/repos/auth_repo.dart';
import 'package:shopak/features/3-auth/presentation/cubit/reset_password_cubit/reset_password_cubit.dart';
import 'package:shopak/features/3-auth/presentation/views/widgets/resetpassword/widget/check_password_bloc_consumer.dart';
import 'package:shopak/generated/l10n.dart';

class CheckEmailView extends StatelessWidget {
  const CheckEmailView({super.key});
  static const routeName = '/forgetPassword';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordCubit(getIt<AuthRepo>()),
      child: Scaffold(
        appBar: customAppBar(
          context,
          title: S.of(context).check_your_email,
          icon: true,
        ),
        body:  CheckPasswordBlocConsumer(),
      ),
    );
  }
}
