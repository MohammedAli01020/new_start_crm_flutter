

import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/custom_edit_text.dart';
import '../../../../core/widgets/default_button_widget.dart';
import '../../../../core/widgets/default_hieght_sized_box.dart';
import '../../data/models/project_model.dart';
import '../../domain/use_cases/projects_use_case.dart';
import '../cubit/project/project_cubit.dart';


class ModifyProjectWidget extends StatefulWidget {
  final ProjectModel? projectModel;
  final ProjectCubit projectCubit;
  final ProjectState state;
  final int developerId;

  const ModifyProjectWidget({Key? key,
    this.projectModel,
    required this.projectCubit,
    required this.state,
    required this.developerId,}) : super(key: key);

  @override
  State<ModifyProjectWidget> createState() => _ModifyProjectWidgetState();
}

class _ModifyProjectWidgetState extends State<ModifyProjectWidget> {
  final formKey = GlobalKey<FormState>();
  int? projectId;
  late int currentDeveloperId;
  final _nameController = TextEditingController();

  @override
  void initState() {

    super.initState();
    if (widget.projectModel != null) {
      projectId = widget.projectModel!.projectId;
      _nameController.text = widget.projectModel!.name;
    }

    currentDeveloperId = widget.developerId;

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
                  hint: "اسم المشروع",
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

                      await widget.projectCubit.modifyProject(ModifyProjectParam(
                          projectId: projectId,
                          name: _nameController.text,
                          developerId: currentDeveloperId));

                      setState(() {
                        isModify = false;
                      });

                      Navigator.pop(context);
                    }

                  }, text: widget.projectModel != null ? "عدل" : "أضف")),

                  if (widget.projectModel != null && Constants.currentEmployee!.permissions.contains(AppStrings.deleteProjects)) const Spacer(flex: 1 ,),

                  if (widget.projectModel != null && Constants.currentEmployee!.permissions.contains(AppStrings.deleteProjects)) Expanded(
                      flex: 4,
                      child: DefaultButtonWidget(onTap: () async {

                        final confirmDelete = await Constants.showConfirmDialog(context: context, msg: "هل تريد تأكيد الحذف؟");

                        if (confirmDelete) {
                          setState(() {
                            isModify = true;
                          });

                          await widget.projectCubit.deleteProject(widget.projectModel!.projectId);

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