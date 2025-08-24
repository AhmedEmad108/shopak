import 'package:flutter/material.dart';
import 'package:shopak/core/utils/app_color.dart';
import 'package:shopak/core/utils/app_style.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onTap,
    this.title,
    this.buttonColor,
    this.textStyle,
    this.width = double.infinity,
    this.height = 54,
    this.child,
  });
  final void Function()? onTap;
  final String? title;
  final Color? buttonColor;
  final TextStyle? textStyle;
  final double width, height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: buttonColor ?? AppColor.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child:
              child ??
              Text(
                title!,
                textAlign: TextAlign.center,
                style:
                    textStyle ??
                    AppStyle.styleBold24().copyWith(color: AppColor.white),
              ),
        ),
      ),
    );
  }
}
