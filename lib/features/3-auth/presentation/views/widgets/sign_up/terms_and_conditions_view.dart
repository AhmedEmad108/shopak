import 'package:flutter/material.dart';
import 'package:shopak/contants.dart';
import 'package:shopak/core/utils/app_color.dart';
import 'package:shopak/core/utils/app_style.dart';
import 'package:shopak/core/widgets/custom_appbar.dart';
import 'package:shopak/core/widgets/custom_button.dart';
import 'package:shopak/features/3-auth/presentation/views/sign_up_view.dart';
import 'package:shopak/generated/l10n.dart';

class TermsAndConditionsView extends StatefulWidget {
  const TermsAndConditionsView({super.key, required this.onChecked});
  static const routeName = '/termsAndConditionsPage';
  final ValueChanged<bool> onChecked;

  @override
  State<TermsAndConditionsView> createState() => _TermsAndConditionsViewState();
}

class _TermsAndConditionsViewState extends State<TermsAndConditionsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context,
        title: S.of(context).terms_and_conditions,
        icon: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).welcome_to_our_application,
                style: AppStyle.styleBold30(),
              ),
              const SizedBox(height: 20),
              Text(
                S.of(context).terms,
                style: AppStyle.styleSemiBold22().copyWith(height: 1.5),
              ),
              const SizedBox(height: 33),
              CustomButton(
                title: S.of(context).agree_continue,
                buttonColor: AppColor.primaryColor,
                textStyle: AppStyle.styleBold24().copyWith(
                  color: AppColor.white,
                ),
                onTap: () {
                  widget.onChecked(true);
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
