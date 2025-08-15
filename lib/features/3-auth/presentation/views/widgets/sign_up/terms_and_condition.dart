import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shopak/core/utils/app_color.dart';
import 'package:shopak/features/3-auth/presentation/views/widgets/sign_up/terms_and_conditions_view.dart';
import 'package:shopak/generated/l10n.dart';

class CustomTermsAndCondition extends StatefulWidget {
  const CustomTermsAndCondition({
    super.key,
    required this.onChanged,
    required this.isAccepted,
  });
  final ValueChanged<bool> onChanged;
  final bool isAccepted;

  @override
  State<CustomTermsAndCondition> createState() =>
      _CustomTermsAndConditionState();
}

class _CustomTermsAndConditionState extends State<CustomTermsAndCondition> {
  bool isTermsAccepted = false;
  void handleCheckboxChange(bool? value) async {
    if (!widget.isAccepted) {
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (_) => TermsAndConditionsView(isAccepted: widget.isAccepted,)),
      );
      if (result == true) {
        widget.onChanged(true);
      }
    } else {
      widget.onChanged(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // CustomCheckBox(
        //   onChecked: (value) {
        //     isTermsAccepted = value;
        //     widget.onChanged(value);
        //     setState(() {});
        //   },
        // ),
        Transform.scale(
          scale: 1.5,
          child: Checkbox(
            value: widget.isAccepted,
            onChanged: handleCheckboxChange,
            // onChanged: (value) => widget.onChanged(value ?? false),
            activeColor: AppColor.primaryColor,
            side: BorderSide(
              color: widget.isAccepted ? Colors.transparent : AppColor.grey6,
              width: 1.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            materialTapTargetSize:
                MaterialTapTargetSize.shrinkWrap, // يقلل المسافة حول علامة الصح
            splashRadius: 0, // يلغي تأثير الـ splash عند الضغط
            visualDensity: VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity,
            ),
          ),
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
                        ..onTap = () async {
                          final result = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TermsAndConditionsView(isAccepted: widget.isAccepted,),
                            ),
                          );

                          if (result == true) {
                            isTermsAccepted = true;
                            widget.onChanged(true);
                            setState(() {});
                          }
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder:
                          //         (context) => TermsAndConditionsView(
                          //         ),
                          //   ),
                          // );
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
