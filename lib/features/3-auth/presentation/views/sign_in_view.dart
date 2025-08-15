import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopak/core/services/get_it.dart';
import 'package:shopak/core/widgets/custom_appbar.dart';
import 'package:shopak/features/3-auth/domain/repos/auth_repo.dart';
import 'package:shopak/features/3-auth/presentation/cubit/signin_cubit/sign_in_cubit.dart';
import 'package:shopak/features/3-auth/presentation/views/widgets/sign_in/sign_in_bloc_consumer.dart';
import 'package:shopak/features/3-auth/presentation/views/widgets/sign_in/sign_in_view_body.dart';
import 'package:shopak/generated/l10n.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});
  static const routeName = '/signin';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInCubit(getIt<AuthRepo>()),
      child: Scaffold(
        appBar: customAppBar(context, title: S.of(context).signin),
        body: SignInBlocConsumer(),
      ),
    );
  }
}
