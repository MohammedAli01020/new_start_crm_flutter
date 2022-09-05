import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

class CircleSkeletonWidget extends StatelessWidget {
  const CircleSkeletonWidget({Key? key, this.size = 24}) : super(key: key);

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 5),
      baseColor: Colors.black,
      highlightColor: Colors.grey,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.04),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}