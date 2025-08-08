import 'package:flutter/material.dart';
import 'package:shopak/core/widgets/custom_appbar.dart';
import 'package:shopak/features/3-auth/presentation/views/widgets/sign_up/sign_up_view_body.dart';
import 'package:shopak/generated/l10n.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});
  static const routeName = '/signup';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: S.of(context).signup, icon: true),
      body: SignUpViewBody(),
    );
  }
}
