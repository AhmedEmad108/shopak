import 'package:flutter/material.dart';
import 'package:shopak/contants.dart';
import 'package:shopak/core/utils/app_color.dart';
import 'package:shopak/core/utils/app_images.dart';
import 'package:shopak/core/utils/app_style.dart';
import 'package:shopak/core/widgets/custom_button.dart';
import 'package:shopak/features/3-auth/presentation/views/sign_in_view.dart';
import 'package:shopak/generated/l10n.dart';
import 'package:shopak/core/widgets/custom_appbar.dart';
import 'package:svg_flutter/svg.dart';

class SuccessResetPasswordView extends StatelessWidget {
  const SuccessResetPasswordView({super.key});
  static const routeName = '/SuccessResetPassword';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: ''),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 80,
            ),
            SvgPicture.asset(
              Assets.imagesDone,
              width: 200,
              height: 150,
            ),
            const SizedBox(
              height: 33,
            ),
            Text(
              S.of(context).congratulations,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              S.of(context).your_password_has_been_changed,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    height: 1.5,
                  ),
            ),
            const SizedBox(
              height: 33,
            ),
            CustomButton(
              title: S.of(context).go_to_login,
              buttonColor: AppColor.primaryColor,
              textStyle: AppStyle.styleBold24().copyWith(
                color: AppColor.white,
              ),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  SignInView.routeName,
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
