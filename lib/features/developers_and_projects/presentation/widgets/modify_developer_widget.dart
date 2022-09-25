
import 'package:crm_flutter_project/features/developers_and_projects/data/models/developer_model.dart';
import 'package:crm_flutter_project/features/developers_and_projects/domain/use_cases/developer_use_case.dart';
import 'package:crm_flutter_project/features/developers_and_projects/presentation/cubit/developer/developer_cubit.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/custom_edit_text.dart';
import '../../../../core/widgets/default_button_widget.dart';
import '../../../../core/widgets/default_hieght_sized_box.dart';


class ModifyDeveloperWidget extends StatefulWidget {
  final DeveloperModel? developerModel;
  final DeveloperCubit developerCubit;
  final DeveloperState state;

  const ModifyDeveloperWidget({Key? key,
    this.developerModel,
    required this.developerCubit,
    required this.state,}) : super(key: key);

  @override
  State<ModifyDeveloperWidget> createState() => _ModifyDeveloperWidgetState();
}

class _ModifyDeveloperWidgetState extends State<ModifyDeveloperWidget> {
  final formKey = GlobalKey<FormState>();
  int? sourceId;
  final _nameController = TextEditingController();

  @override
  void initState() {

    super.initState();
    if (widget.developerModel != null) {
      sourceId = widget.developerModel!.developerId;
      _nameController.text = widget.developerModel!.name;
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
                  hint: "اسم المطور",
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

                      await widget.developerCubit.modifyDeveloper(ModifyDeveloperParam(
                          developerId: sourceId,
                          name: _nameController.text));

                      setState(() {
                        isModify = false;
                      });

                      Navigator.pop(context);
                    }

                  }, text: widget.developerModel != null ? "عدل" : "أضف")),

                  if (widget.developerModel != null && Constants.currentEmployee!.permissions.contains(AppStrings.deleteDevelopers)) const Spacer(flex: 1 ,),

                  if (widget.developerModel != null && Constants.currentEmployee!.permissions.contains(AppStrings.deleteDevelopers)) Expanded(
                      flex: 4,
                      child: DefaultButtonWidget(onTap: () async {

                        final confirmDelete = await Constants.showConfirmDialog(context: context, msg: "هل تريد تأكيد الحذف؟");

                        if (confirmDelete) {
                          setState(() {
                            isModify = true;
                          });

                          await widget.developerCubit.deleteDeveloper(widget.developerModel!.developerId);

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