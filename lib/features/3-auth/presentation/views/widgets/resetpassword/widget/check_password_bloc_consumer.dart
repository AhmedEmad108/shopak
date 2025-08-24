import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopak/core/utils/app_color.dart';
import 'package:shopak/core/utils/app_images.dart';
import 'package:shopak/core/widgets/custom_dialog.dart';
import 'package:shopak/core/widgets/loading_dialog.dart';
import 'package:shopak/core/widgets/show_snackbar.dart';
import 'package:shopak/features/3-auth/presentation/cubit/reset_password_cubit/reset_password_cubit.dart';
import 'package:shopak/features/3-auth/presentation/views/widgets/resetpassword/widget/check_email_view_body.dart';
import 'package:shopak/generated/l10n.dart';

class CheckPasswordBlocConsumer extends StatelessWidget {
  const CheckPasswordBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordLoading) {
          loadingDialog(context);
        }
        if (state is ResetPasswordSuccess) {
          Navigator.pop(context);
          Navigator.pop(context);
          showSnackBar(context, S.of(context).check_your_email, AppColor.green);
        }
        if (state is ResetPasswordError) {
          Navigator.pop(context);
          customDialog(
            context,
            title: state.message,
            image: Assets.imagesError,
          );
        }
      },
      builder: (context, state) {
        return CheckEmailViewBody();
      },
    );
  }
}
