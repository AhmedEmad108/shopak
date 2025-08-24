import 'package:flutter/material.dart';
import 'package:shopak/core/widgets/custom_appbar.dart';
import 'package:shopak/features/3-auth/presentation/views/widgets/resetpassword/reset_password_view.dart';
import 'package:shopak/features/3-auth/presentation/views/widgets/resetpassword/widget/verify_code_view_body.dart';
import 'package:shopak/generated/l10n.dart';

class VerifyCodeResetPassView extends StatelessWidget {
  const VerifyCodeResetPassView({super.key, required this.email});
  static const routeName = '/verifyCodeResetPassView';

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context,
          title: S.of(context).verification_code, icon: true),
      body: VerifyCodeViewBody(
        onTap: () {
          Navigator.of(context).pushNamed(ResetPasswordView.routeName);
        },
        email: email,
      ),
    );
  }
}
