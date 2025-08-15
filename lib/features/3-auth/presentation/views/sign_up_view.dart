import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopak/core/services/get_it.dart';
import 'package:shopak/core/widgets/custom_appbar.dart';
import 'package:shopak/features/3-auth/domain/repos/auth_repo.dart';
import 'package:shopak/features/3-auth/presentation/cubit/signup_cubit/sign_up_cubit.dart';
import 'package:shopak/features/3-auth/presentation/views/widgets/sign_up/sign_up_view_bloc_consumer.dart';
import 'package:shopak/generated/l10n.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});
  static const routeName = '/signup';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(getIt<AuthRepo>()),
      child: Scaffold(
        appBar: customAppBar(context, title: S.of(context).signup, icon: true),
        body: SignUpViewBlocConsumer(),
      ),
    );
  }
}
