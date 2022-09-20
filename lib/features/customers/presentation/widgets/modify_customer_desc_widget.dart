import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_edit_text.dart';
import '../../../../core/widgets/default_button_widget.dart';
import '../../../../core/widgets/default_hieght_sized_box.dart';
import '../../data/models/customer_model.dart';
import '../cubit/customer_cubit.dart';

class ModifyCustomerDescWidget extends StatefulWidget {
  final CustomerCubit customerCubit;
  final CustomerModel customerModel;

  final Function onTapCallBack;

  const ModifyCustomerDescWidget(
      {Key? key,
      required this.customerCubit,
      required this.customerModel,
      required this.onTapCallBack})
      : super(key: key);

  @override
  State<ModifyCustomerDescWidget> createState() =>
      _ModifyCustomerDescWidgetState();
}

class _ModifyCustomerDescWidgetState extends State<ModifyCustomerDescWidget> {
  final formKey = GlobalKey<FormState>();

  late int customerId;
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    customerId = widget.customerModel.customerId;
    _descriptionController.text = widget.customerModel.description != null &&
            widget.customerModel.description!.isNotEmpty
        ? widget.customerModel.description!
        : "";
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
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
                        controller: _descriptionController,
                        hint: "ملاحظة عن العميل",
                        validator: (v) {
                          if (v == null && v!.isNotEmpty) {
                            if (v.length > 5000) {
                              return "اقصي عدد احرف 5000";
                            }
                          }

                          return null;
                        },
                        inputType: TextInputType.multiline,
                        minLines: 3,
                        maxLines: 14,
                        maxLength: 5000),
                    const DefaultHeightSizedBox(),
                    DefaultButtonWidget(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            widget.onTapCallBack(_descriptionController.text);
                          }
                        },
                        text: "عدل")
                  ],
                ),
        ),
      ),
    );
  }
}
