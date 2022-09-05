
import 'package:flutter/material.dart';
import '../../config/locale/app_localizations.dart';
import '../utils/app_colors.dart';
import 'custom_button_widget.dart';

class ErrorItemWidget extends StatelessWidget {
  final VoidCallback? onPress;
  final String msg;
  const ErrorItemWidget({Key? key, this.onPress, this.msg = "something wrong"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Icon(
            Icons.warning_amber_rounded,
            color: AppColors.primary,
            size: 150,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            msg,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        Text(
          AppLocalizations.of(context)!.translate('try_again')!,
          style: TextStyle(
              color: AppColors.hint, fontSize: 18, fontWeight: FontWeight.w500),
        ),


        CustomButtonWidget(onPress: onPress, text: AppLocalizations.of(context)!.translate('reload_screen')!,)

      ],
    );
  }
}




