import 'package:flutter/material.dart';

import '../utils/constants.dart';

class WaitingItemWidget extends StatelessWidget {
  const WaitingItemWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Constants.showToast(msg: "انتظر حتي ينتهي التحميل", context: context);
        return false;
      },
      child: Scaffold(
          appBar: AppBar(),
          body: const Center(
            child: CircularProgressIndicator(),
          )),
    );
  }
}
