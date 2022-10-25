import 'package:flutter/material.dart';

class FilterField extends StatelessWidget {
  final Widget text;
  final Color? backgroundColor;

   const FilterField({Key? key, required this.text,
     this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      padding: const EdgeInsets.all(5.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        // borderRadius: BorderRadius.circular(2.0),
        border: Border.all(color: Colors.blueGrey),
      ),
      child: text,
    );
  }
}
