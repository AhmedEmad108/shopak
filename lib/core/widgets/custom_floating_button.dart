
import 'package:flutter/material.dart';
import 'package:shopak/contants.dart';
import 'package:shopak/core/utils/app_color.dart';
import 'package:shopak/core/utils/app_style.dart';
import 'package:shopak/core/widgets/custom_button.dart';

class CustomFloatingButton extends StatelessWidget {
  const CustomFloatingButton({
    super.key,
    required this.onTap,
    required this.title,
  });
  final void Function()? onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: kHorizontalPadding,
        left: kHorizontalPadding,
        right: kHorizontalPadding,
      ),
      child: CustomButton(
        title: title,
        buttonColor: AppColor.primaryColor,
        textStyle: AppStyle.styleBold24().copyWith(color: AppColor.white,),
        onTap: onTap,
      ),
    );
  }
}
