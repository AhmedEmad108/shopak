import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopak/core/utils/app_color.dart';
import 'package:shopak/core/utils/app_images.dart';
import 'package:shopak/core/widgets/custom_dialog.dart';
import 'package:shopak/core/widgets/loading_dialog.dart';
import 'package:shopak/core/widgets/show_snackbar.dart';
import 'package:shopak/features/3-auth/presentation/views/sign_in_view.dart';
import 'package:shopak/features/5-profile/presentation/views/edit_email/cubit/edit_email_cubit.dart';
import 'package:shopak/features/5-profile/presentation/views/edit_email/widgets/change_email_view_body.dart';

class ChangeEmailViewBlocConsumer extends StatelessWidget {
  const ChangeEmailViewBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditEmailCubit, EditEmailState>(
      listener: (context, state) {
        if (state is EditEmailLoading) {
          Navigator.pop(context);
          loadingDialog(context);
        }
        if (state is EditEmailSuccess) {
          Navigator.pop(context);
          FirebaseAuth.instance.signOut().then((value) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(SignInView.routeName, (route) => false);
          });
          showSnackBar(
            context,
            state.message, // الرسالة اللي بتيجي من الكيوبت
            AppColor.green,
          );
        }
        if (state is EditEmailFailed) {
          Navigator.pop(context);
          customDialog(context, title: state.error, image: Assets.imagesError);
        }
      },
      builder: (context, state) {
        return const ChangeEmailViewBody();
      },
    );
  }
}