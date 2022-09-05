import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class HandDragWidget extends StatelessWidget {
  const HandDragWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3.0),
        height: 4.0,
        width: 50.0,
        decoration: BoxDecoration(
            color: AppColors.hint.withOpacity(0.7),
            borderRadius: BorderRadius.circular(3.0)),
      ),
    );
  }
}
