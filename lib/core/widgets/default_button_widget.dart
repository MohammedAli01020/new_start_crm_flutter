import 'package:flutter/material.dart';
class DefaultButtonWidget extends StatelessWidget {
  const DefaultButtonWidget({Key? key, required this.onTap, required this.text, this.color, this.fontSize}) : super(key: key);

  final VoidCallback onTap;
  final String text;
  final Color? color;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: Material(
        color: color ?? Theme.of(context).primaryColor,
        elevation: 5.0,
        child: MaterialButton(
          child: Text(text, style: TextStyle(color: Colors.white, fontSize: fontSize ?? 16.0),),
          onPressed: onTap,
        ),
      ),
    );
  }
}
