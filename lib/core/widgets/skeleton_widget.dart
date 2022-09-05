import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonWidget extends StatelessWidget {
  const SkeletonWidget({Key? key, this.height, this.width, this.radius})
      : super(key: key);

  final double? height, width;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 1000),
      baseColor: Colors.black,
      highlightColor: Colors.grey,
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.04),
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 0))),
      ),
    );
  }
}
