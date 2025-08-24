
import 'package:flutter/material.dart';

class RtlImage extends StatelessWidget {
  final String path;
  final double? height;
  final BoxFit fit;
  final bool rtl;

  const RtlImage({
    super.key,
    required this.path,
    this.height,
    this.fit = BoxFit.contain,
    required this.rtl,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..scale(isRtl && rtl ? -1.0 : 1.0, 1.0),
      child: Image.asset(path, height: height, fit: fit),
    );
  }
}
