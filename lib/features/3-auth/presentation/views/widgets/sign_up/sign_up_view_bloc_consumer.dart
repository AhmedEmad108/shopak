import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopak/core/utils/app_color.dart';
import 'package:shopak/core/utils/app_images.dart';
import 'package:shopak/core/widgets/custom_dialog.dart';
import 'package:shopak/core/widgets/loading_dialog.dart';
import 'package:shopak/core/widgets/show_snackbar.dart';
import 'package:shopak/features/3-auth/presentation/cubit/signup_cubit/sign_up_cubit.dart';
import 'package:shopak/features/3-auth/presentation/views/widgets/sign_up/sign_up_view_body.dart';
import 'package:shopak/generated/l10n.dart';

class SignUpViewBlocConsumer extends StatelessWidget {
  const SignUpViewBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state is SignUpLoading) {
          loadingDialog(context);
        }
        if (state is SignUpSuccess) {
          Navigator.pop(context);
          Navigator.pop(context);
          showSnackBar(
            context,
            '${S.of(context).successfully_created_account}\n${S.of(context).please_verify_your_email}',
            AppColor.green,
          );
        }
        if (state is SignUpError) {
          Navigator.pop(context);
          customDialog(
            context,
            message: state.message,
            image: Assets.imagesError,
          );
        }
      },
      builder: (context, state) {
        return const SignUpViewBody();
      },
    );
  }
}
