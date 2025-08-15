import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopak/core/utils/app_color.dart';
import 'package:shopak/core/utils/app_images.dart';
import 'package:shopak/core/widgets/custom_dialog.dart';
import 'package:shopak/core/widgets/loading_dialog.dart';
import 'package:shopak/core/widgets/show_snackbar.dart';
import 'package:shopak/features/3-auth/presentation/cubit/signin_cubit/sign_in_cubit.dart';
import 'package:shopak/features/3-auth/presentation/views/widgets/sign_in/sign_in_view_body.dart';
import 'package:shopak/features/4-main_view/presentation/views/main_view.dart';
import 'package:shopak/generated/l10n.dart';

class SignInBlocConsumer extends StatelessWidget {
  const SignInBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state is SignInLoading) {
          loadingDialog(context);
        }
        if (state is SignInSuccess) {
          Navigator.pop(context);
          Navigator.pushNamed(context, MainView.routeName);
          showSnackBar(
            context,
            S.of(context).successfully_signed_in,
            AppColor.green,
          );
        }
        if (state is SignInError) {
          Navigator.pop(context);
          customDialog(
            context,
            message: state.message,
            image: Assets.imagesError,
          );
        }
      },
      builder: (context, state) {
        return const SignInViewBody();
      },
    );
  }
}
