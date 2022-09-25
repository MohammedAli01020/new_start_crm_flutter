import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/custom_edit_text.dart';
import '../../../../core/widgets/default_button_widget.dart';
import '../../../../core/widgets/default_hieght_sized_box.dart';

class EditCustomerPhoneNumber extends StatefulWidget {
  final List<String> phoneNumbers;
  final Function onDoneCallback;

  const EditCustomerPhoneNumber({Key? key, required this.phoneNumbers,
    required this.onDoneCallback})
      : super(key: key);

  @override
  State<EditCustomerPhoneNumber> createState() =>
      _EditCustomerPhoneNumberState();
}

class _EditCustomerPhoneNumberState extends State<EditCustomerPhoneNumber> {
  final formKey = GlobalKey<FormState>();

  final _firstPhoneController = TextEditingController();
  final _secondPhoneController = TextEditingController();
  late List<String> currentPhoneNumbers;


  @override
  void initState() {
    super.initState();
    currentPhoneNumbers = widget.phoneNumbers;

    if (currentPhoneNumbers.length == 1) {
      _firstPhoneController.text = currentPhoneNumbers.first;
    } else if (currentPhoneNumbers.length == 2) {
      _firstPhoneController.text = currentPhoneNumbers.first;
      _secondPhoneController.text = currentPhoneNumbers.elementAt(1);
    }

  }

  @override
  void dispose() {
    super.dispose();
    _firstPhoneController.dispose();
    _secondPhoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500.0,
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [


            CustomEditText(
                controller: _firstPhoneController,
                hint: "رقم الهاتف الأول",
                maxLength: 50,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return AppStrings.required;
                  }

                  if (v.length > 50) {
                    return "اقصي عدد احرف 50";
                  }

                  return null;
                },
                inputType: TextInputType.phone),
            const DefaultHeightSizedBox(),
            CustomEditText(
                controller: _secondPhoneController,
                hint: "رقم الهاتف الثاني",
                maxLength: 50,
                validator: (v) {

                  if (v != null && v.length > 50) {
                    return "اقصي عدد احرف 50";
                  }

                  return null;
                },
                inputType: TextInputType.phone),
            const DefaultHeightSizedBox(),



            DefaultButtonWidget(onTap: () {
              if (formKey.currentState!.validate()) {

                if (_firstPhoneController.text.trim() == _secondPhoneController.text.trim() ) {
                  Constants.showToast(msg: "الرقمين متشابهين", context: context);
                  return;
                }


                if (_firstPhoneController.text.isNotEmpty && _secondPhoneController.text.isNotEmpty) {
                  currentPhoneNumbers = [
                    _firstPhoneController.text.trim(),
                    _secondPhoneController.text.trim()
                  ];
                } else {
                  currentPhoneNumbers = [
                    _firstPhoneController.text.trim()
                  ];
                }

                widget.onDoneCallback(currentPhoneNumbers);
                Navigator.pop(context);
              }

            }, text: "تأكيد")
          ],
        ),
      ),
    );
  }
}