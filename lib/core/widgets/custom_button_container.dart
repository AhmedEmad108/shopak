import 'package:flutter/material.dart';
import 'package:shopak/core/utils/app_color.dart';

class CustomButtonContainer extends StatelessWidget {
  const CustomButtonContainer({
    super.key,
    required this.onTap,
    required this.text,
    required this.icon,
    required this.color,
    required this.borderRadius,
  });

  final void Function()? onTap;
  final String text;
  final IconData icon;
  final Color color;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: color, borderRadius: borderRadius),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: AppColor.black),
            const SizedBox(width: 5),
            Text(
              text,
              style: Theme.of(context).textTheme.titleSmall!.copyWith( 
                color: AppColor.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
