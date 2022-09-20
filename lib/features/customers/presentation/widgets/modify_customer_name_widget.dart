
import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/custom_edit_text.dart';
import '../../../../core/widgets/default_button_widget.dart';
import '../../../../core/widgets/default_hieght_sized_box.dart';
import '../../data/models/customer_model.dart';
import '../cubit/customer_cubit.dart';


class ModifyCustomerNameWidget extends StatefulWidget {

  final CustomerCubit customerCubit;
  final CustomerModel customerModel;

  final Function onTapCallBack;

  const ModifyCustomerNameWidget({
    Key? key, required this.customerCubit, required this.customerModel,
    required this.onTapCallBack
  }) : super(key: key);

  @override
  State<ModifyCustomerNameWidget> createState() => _ModifyCustomerNameWidgetState();
}

class _ModifyCustomerNameWidgetState extends State<ModifyCustomerNameWidget> {
  final formKey = GlobalKey<FormState>();

  late int customerId;
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    customerId = widget.customerModel.customerId;
    _nameController.text =  widget.customerModel.fullName;
  }



  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  bool isModify = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: 500.0,
        child: Form(
          key: formKey,
          child: isModify
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomEditText(
                        controller: _nameController,
                        hint: "اسم العميل",
                        maxLength: 50,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return AppStrings.required;
                          }

                          if (v.length > 50) {
                            return "اقصي عدد احرف 50";
                          }

                          if (v.length < 2) {
                            return "اقل عدد احرف 2";
                          }

                          return null;
                        },
                        inputType: TextInputType.text),
                    const DefaultHeightSizedBox(),
                    DefaultButtonWidget(onTap: () {
                      if (formKey.currentState!.validate()) {
                        widget.onTapCallBack(_nameController.text);
                      }
                    }, text: "عدل")
                  ],
                ),
        ),
      ),
    );
  }
}
