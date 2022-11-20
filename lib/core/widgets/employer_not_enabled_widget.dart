

import 'dart:io';

import 'package:flutter/material.dart';

import '../../config/routes/app_routes.dart';
import '../../features/login/presentation/cubit/login_cubit.dart';
import 'default_button_widget.dart';
import 'default_hieght_sized_box.dart';

class EmployeeNotEnabledWidget extends StatelessWidget {
  final String message;
  final LoginCubit loginCubit;
  const EmployeeNotEnabledWidget({Key? key, required this.message,
    required this.loginCubit}) : super(key: key);

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
            }, text: "خروج"),

            const DefaultHeightSizedBox(),
            DefaultButtonWidget(onTap: () {
              loginCubit.returnToLogin();
            }, text: "تسجيل الدخول مرة اخرة")
          ],
        ),

      ),
    );
  }
}
