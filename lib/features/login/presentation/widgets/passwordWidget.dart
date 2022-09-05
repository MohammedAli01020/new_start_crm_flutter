import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/custom_edit_text.dart';

class PasswordWidget extends StatefulWidget {
  final TextEditingController passwordController;
  final String hint;
  const PasswordWidget({Key? key, required this.passwordController, required this.hint}) : super(key: key);

  @override
  State<PasswordWidget> createState() => _PasswordWidgetState();
}

class _PasswordWidgetState extends State<PasswordWidget> {

  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return CustomEditText(
        hint: widget.hint,
        controller: widget.passwordController,
        inputType: TextInputType.visiblePassword,

        maxLines: 1,
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _isVisible = !_isVisible;
              });
            },
            icon: _isVisible
                ? const Icon(Icons.visibility_off_outlined,)
                : const Icon(Icons.visibility_outlined,)),
        isPassword: !_isVisible,

        validator: (v) {
          if (v == null || v.isEmpty) {
            return AppStrings.required;
          }
          if (v.length < 7) {
            return "اقل عدد احرف 7";
          }
          return null;
        }

    );
  }
}
