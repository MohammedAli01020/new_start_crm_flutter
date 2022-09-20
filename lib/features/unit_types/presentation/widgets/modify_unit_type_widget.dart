
import 'package:crm_flutter_project/core/utils/constants.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/custom_edit_text.dart';
import '../../../../core/widgets/default_button_widget.dart';
import '../../../../core/widgets/default_hieght_sized_box.dart';
import '../../data/models/unti_type_model.dart';
import '../../domain/use_cases/unit_types_use_cases.dart';
import '../cubit/unit_type_cubit.dart';


class ModifyUnitTypeWidget extends StatefulWidget {
  final UnitTypeModel? unitTypeModel;
  final UnitTypeCubit unitTypeCubit;
  final UnitTypeState state;

  const ModifyUnitTypeWidget({Key? key,
    this.unitTypeModel,
    required this.unitTypeCubit,
    required this.state,}) : super(key: key);

  @override
  State<ModifyUnitTypeWidget> createState() => _ModifyUnitTypeWidgetState();
}

class _ModifyUnitTypeWidgetState extends State<ModifyUnitTypeWidget> {
  final formKey = GlobalKey<FormState>();
  int? unitTypeId;
  final _nameController = TextEditingController();

  @override
  void initState() {

    super.initState();
    if (widget.unitTypeModel != null) {
      unitTypeId = widget.unitTypeModel!.unitTypeId;
      _nameController.text = widget.unitTypeModel!.name;
    }
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
          child: isModify ?
          const  Center(child:  CircularProgressIndicator()):
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomEditText(
                  controller: _nameController,
                  hint: "اسم العنصر",
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

              Row(
                children: [
                  Expanded(
                      flex: 4,
                      child: DefaultButtonWidget(onTap: () async {

                    if (formKey.currentState!.validate()) {
                      setState(() {
                        isModify = true;
                      });

                      await widget.unitTypeCubit.modifyUnitType(ModifyUnitTypeParam(
                          unitTypeId: unitTypeId,
                          name: _nameController.text));

                      setState(() {
                        isModify = false;
                      });

                      Navigator.pop(context);
                    }

                  }, text: widget.unitTypeModel != null ? "عدل" : "أضف")),

                  if (widget.unitTypeModel != null && Constants.currentEmployee!.permissions.contains(AppStrings.deleteUnitTypes))const Spacer(flex: 1 ,),

                  if (widget.unitTypeModel != null && Constants.currentEmployee!.permissions.contains(AppStrings.deleteUnitTypes)) Expanded(
                      flex: 4,
                      child: DefaultButtonWidget(onTap: () async {


                       final confirmDelete = await Constants.showConfirmDialog(context: context, msg: "هل تريد تأكيد الحذف؟");
                       if (confirmDelete) {
                         setState(() {
                           isModify = true;
                         });

                         await widget.unitTypeCubit.deleteUnitType(widget.unitTypeModel!.unitTypeId);

                         setState(() {
                           isModify = false;
                         });

                         Navigator.pop(context);
                       }

                      }, text: "حذف")),

                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}