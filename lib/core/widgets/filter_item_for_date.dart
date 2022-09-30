

import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class FilterItemForDate extends StatelessWidget {
  final VoidCallback onTapCallback;
  final String text;
  final int? startDateMillis;
  final int? endDateMillis;
  final int? currentStartDateMillis;
  final int? currentEndDateMillis;

  const FilterItemForDate({
    Key? key,
    required this.onTapCallback,
    required this.text,
    required this.startDateMillis,
    required this.endDateMillis,
    required this.currentStartDateMillis,
    required this.currentEndDateMillis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapCallback,
      child: Container(
        margin: const EdgeInsets.only(left: 10.0),
        padding: const EdgeInsets.all(5.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: startDateMillis == currentStartDateMillis &&
              endDateMillis == currentEndDateMillis
              ? AppColors.primary.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(
              color: startDateMillis == currentStartDateMillis &&
                  endDateMillis == currentEndDateMillis
                  ? AppColors.primary
                  : AppColors.hint),
        ),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 14.0,
              color: startDateMillis == currentStartDateMillis &&
                  endDateMillis == currentEndDateMillis
                  ? AppColors.primary
                  : AppColors.hint),
        ),
      ),
    );
  }
}