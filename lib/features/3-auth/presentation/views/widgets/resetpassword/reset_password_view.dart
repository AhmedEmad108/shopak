import 'package:flutter/material.dart';
import 'package:shopak/core/widgets/custom_appbar.dart';
import 'package:shopak/features/3-auth/presentation/views/widgets/resetpassword/widget/reset_password_view_body.dart';
import 'package:shopak/generated/l10n.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});
  static const routeName = '/resetPassword';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context,
          title: S.of(context).reset_password, icon: true),
      body: const ResetPasswordViewBody(),
    );
  }
}
