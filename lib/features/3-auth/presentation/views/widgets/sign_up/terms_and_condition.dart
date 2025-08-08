import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shopak/core/utils/app_color.dart';
import 'package:shopak/features/3-auth/presentation/views/widgets/sign_up/custom_check_box_state.dart';
import 'package:shopak/features/3-auth/presentation/views/widgets/sign_up/terms_and_conditions_view.dart';
import 'package:shopak/generated/l10n.dart';

class CustomTermsAndCondition extends StatefulWidget {
  const CustomTermsAndCondition({super.key, required this.onChanged});
  final ValueChanged<bool> onChanged;

  @override
  State<CustomTermsAndCondition> createState() =>
      _CustomTermsAndConditionState();
}

class _CustomTermsAndConditionState extends State<CustomTermsAndCondition> {
  bool isTermsAccepted = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomCheckBox(
          onChecked: (value) {
            isTermsAccepted = value;
            widget.onChanged(value);
            setState(() {});
          },
        ),
        const SizedBox(width: 16),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodySmall,
              children: [
                TextSpan(text: S.of(context).terms_and_condition1),
                TextSpan(
                  text: S.of(context).terms_and_condition2,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: AppColor.primaryColor,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => TermsAndConditionsView(
                                    onChecked: (value) {
                                      isTermsAccepted = value;
                                      widget.onChanged(value);
                                      setState(() {});
                                    },
                                  ),
                            ),
                          );
                        },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
