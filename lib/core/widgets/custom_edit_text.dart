
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomEditText extends StatelessWidget {
  const CustomEditText(
      {Key? key,
      this.hint,
      required this.controller,
      this.validator,
      this.isPassword = false,
      this.prefixIcon,
      this.suffixIcon,
      required this.inputType,
      this.inputFormatter,
      this.maxLength,
      this.autoFocus = false,
      this.label,
      this.onChangedCallback,
        this.maxLines,
        this.minLines,
        this.enabled})
      : super(key: key);

  final String? hint;
  final String? label;

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isPassword;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType inputType;
  final List<TextInputFormatter>? inputFormatter;
  final int? maxLength;
  final bool autoFocus;
  final Function? onChangedCallback;
  final int? maxLines;
  final int? minLines;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChangedCallback != null
          ? (v) {
              onChangedCallback!(v);
            }
          : null,
      style: const TextStyle(fontSize: 20.0),
      keyboardType: inputType,
      decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon),
      validator: validator,
      obscureText: isPassword,
      inputFormatters: inputFormatter ?? [],
      maxLength: maxLength,
      maxLines: maxLines,
      minLines: minLines,
      autofocus: autoFocus,
      enabled: enabled,
    );
  }
}
