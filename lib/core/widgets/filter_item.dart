import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class FilterItem extends StatelessWidget {
  final VoidCallback onTapCallback;
  final String text;
  final String? value;
  final String? currentValue;

  const FilterItem({
    Key? key,
    required this.onTapCallback,
    required this.text,
    required this.value,
    required this.currentValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapCallback,
      child: Container(
        margin: const EdgeInsets.only(left: 10.0),
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: value == currentValue
              ? AppColors.primary.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(
              color:
              value == currentValue ? AppColors.primary : AppColors.hint),
        ),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 14.0,
              color:
              value == currentValue ? AppColors.primary : AppColors.hint),
        ),
      ),
    );
  }
}