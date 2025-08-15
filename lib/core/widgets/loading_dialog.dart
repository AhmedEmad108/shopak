import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shopak/core/utils/app_images.dart';

loadingDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => Center(
      child: Lottie.asset(
        Assets.imagesLoading,
        height: 200,
        width: 200,
      ),
    ),
  );
}
