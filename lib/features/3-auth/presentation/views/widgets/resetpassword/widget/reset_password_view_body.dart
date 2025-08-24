import 'package:flutter/material.dart';
import 'package:shopak/contants.dart';
import 'package:shopak/core/utils/app_color.dart';
import 'package:shopak/core/utils/app_style.dart';
import 'package:shopak/core/widgets/custom_button.dart';
import 'package:shopak/core/widgets/custom_password_text_field.dart';
import 'package:shopak/features/3-auth/presentation/views/widgets/resetpassword/success_reset_password_view.dart';
import 'package:shopak/generated/l10n.dart';

class ResetPasswordViewBody extends StatefulWidget {
  const ResetPasswordViewBody({
    super.key,
  });

  @override
  State<ResetPasswordViewBody> createState() => _ResetPasswordViewBodyState();
}

class _ResetPasswordViewBodyState extends State<ResetPasswordViewBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  late String password, confirmPassword;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
      child: Form(
        key: formKey,
        autovalidateMode: autoValidateMode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 80,
            ),
            Text(
              S.of(context).create_new_password,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              S.of(context).your_new_password,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    height: 1.5,
                  ),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomPasswordTextField(
              onSaved: (value) {
                password = value!;
              },
              hintText: S.of(context).password, label: S.of(context).password,
              
            ),
            const SizedBox(
              height: 20,
            ),
            CustomPasswordTextField(
              onSaved: (value) {
                confirmPassword = value!;
              },
              hintText: S.of(context).confirm_password,
              label: S.of(context).confirm_password,
            ),
            const SizedBox(
              height: 33,
            ),
            CustomButton(
              title: S.of(context).save,
              buttonColor: AppColor.primaryColor,
              textStyle: AppStyle.styleBold24().copyWith(
                color: AppColor.white,
              ),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  SuccessResetPasswordView.routeName,
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
