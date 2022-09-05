import 'dart:io';


import 'package:flutter/material.dart';

import 'default_button_widget.dart';
import 'default_hieght_sized_box.dart';

class EmployeeNotEnabledWidget extends StatelessWidget {
  final String message;
  const EmployeeNotEnabledWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("الحسبا متوقف"),
            Text(message, textAlign: TextAlign.center,),
            const DefaultHeightSizedBox(),
            DefaultButtonWidget(onTap: () {
              exit(0);
            }, text: "خروج")
          ],
        ),

      ),
    );
  }
}
