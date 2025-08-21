import 'package:flutter/material.dart';
import 'package:shopak/core/utils/app_color.dart';

void customSnackBar(BuildContext context, {required String message}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor:
          isDark ? AppColor.darkPrimaryColor : AppColor.lightPrimaryColor,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColor.white,
                fontWeight: FontWeight.bold,
              ),

              // const TextStyle(
              //   fontWeight: FontWeight.bold,
              //   color: Colors.white,
              //   fontSize: 16,
              // ),
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}
