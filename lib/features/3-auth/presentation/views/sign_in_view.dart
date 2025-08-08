import 'package:flutter/material.dart';
import 'package:shopak/core/widgets/custom_appbar.dart';
import 'package:shopak/features/3-auth/presentation/views/widgets/sign_in/sign_in_view_body.dart';
import 'package:shopak/generated/l10n.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});
  static const routeName = '/signin';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: S.of(context).signin),
      body: SignInViewBody(),
    );
  }
}
