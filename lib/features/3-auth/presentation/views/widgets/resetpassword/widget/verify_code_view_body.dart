import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:shopak/contants.dart';
import 'package:shopak/core/utils/app_color.dart';
import 'package:shopak/core/utils/app_style.dart';
import 'package:shopak/core/widgets/custom_button.dart';
import 'package:shopak/features/3-auth/presentation/views/widgets/sign_up/dont_have_account_widget.dart';
import 'package:shopak/generated/l10n.dart';

class VerifyCodeViewBody extends StatelessWidget {
  const VerifyCodeViewBody({
    super.key,
    required this.onTap,
    required this.email,
  });
  final void Function() onTap;
  final String email;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 80,
            ),
            Text(
              S.of(context).check_code,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: S.of(context).please_enter_your_verification_code,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          height: 1.5,
                        ),
                  ),
                  TextSpan(
                    text: email,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColor.primaryColor,
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 33,
            ),
            OtpTextField(
              numberOfFields: 5,
              fieldWidth: size.width * 0.16,
              fieldHeight: 120,
              borderColor: Theme.of(context).primaryColor,
              // disabledBorderColor: AppColor.black,
              enabledBorderColor: Theme.of(context).colorScheme.secondary,
              focusedBorderColor: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(8),
              showFieldAsBox: true,
              fillColor: Theme.of(context).colorScheme.tertiary,
              filled: true,
              textStyle: Theme.of(context).textTheme.bodyMedium,
              onCodeChanged: (String code) {},
              onSubmit: (String verificationCode) {
                // controller.verifyCode = verificationCode;
              },
            ),
            const SizedBox(
              height: 33,
            ),
            CustomButton(
              title: S.of(context).verify_code,
              buttonColor: AppColor.primaryColor,
              textStyle: AppStyle.styleBold24().copyWith(
                color: AppColor.white,
              ),
              onTap: onTap,
            ),
            const SizedBox(
              height: 20,
            ),
            HaveOrDontHaveAccountWidget(
              text: S.of(context).didnot_receive_code,
              text2: S.of(context).resend_code,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
