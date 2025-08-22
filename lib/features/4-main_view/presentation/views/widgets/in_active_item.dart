import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

class InActiveItem extends StatelessWidget {
  const InActiveItem({super.key, required this.image, required this.text});

  final String image;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 4),
            SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: SvgPicture.asset(
                  image,
                  width: 24,
                  height: 24,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    // color: AppColor.primaryColor
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
    // return Center(
    //   child: SvgPicture.asset(
    //     image,
    //     width: 32,
    //     height: 32,
    //     color: Theme.of(context).colorScheme.secondary,
    //   ),
    // );
  }
}
