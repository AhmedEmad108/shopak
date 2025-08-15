import 'package:flutter/material.dart';
import 'package:shopak/core/utils/app_style.dart';
import 'package:svg_flutter/svg.dart';

customDialog(BuildContext context, {required String message, String? image}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          image == null
              ? Container()
              : SvgPicture.asset(
                  image,
                  height: 100,
                  width: 100,
                ),
          SizedBox(
            height: image == null ? 0 : 16,
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppStyle.styleBold22(),
          ),
        ],
      ),
    ),
  );
}
