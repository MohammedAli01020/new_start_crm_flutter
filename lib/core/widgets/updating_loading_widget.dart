
import 'package:flutter/material.dart';

import 'default_hieght_sized_box.dart';

class UpdatingLoadingWidget extends StatelessWidget {
  const UpdatingLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:  SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              DefaultHeightSizedBox(),
              Text("جاري التعديل ...")
            ],
          ),
        ),
      ),
    );
  }
}
