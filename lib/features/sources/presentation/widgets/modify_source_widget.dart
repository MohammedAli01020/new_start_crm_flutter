
import 'package:crm_flutter_project/features/sources/domain/use_cases/sources_use_cases.dart';
import 'package:crm_flutter_project/features/sources/presentation/cubit/source_cubit.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/custom_edit_text.dart';
import '../../../../core/widgets/default_button_widget.dart';
import '../../../../core/widgets/default_hieght_sized_box.dart';
import '../../data/models/source_model.dart';
import '../cubit/source_cubit.dart';

class ModifySourceWidget extends StatefulWidget {
  final SourceModel? sourceModel;
  final SourceCubit sourceCubit;
  final SourceState state;

  const ModifySourceWidget({Key? key,
    this.sourceModel,
    required this.sourceCubit,
    required this.state,}) : super(key: key);

  @override
  State<ModifySourceWidget> createState() => _ModifySourceWidgetState();
}

class _ModifySourceWidgetState extends State<ModifySourceWidget> {
  final formKey = GlobalKey<FormState>();
  int? sourceId;
  final _nameController = TextEditingController();

  @override
  void initState() {

    super.initState();
    if (widget.sourceModel != null) {
      sourceId = widget.sourceModel!.sourceId;
      _nameController.text = widget.sourceModel!.name;
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
                  hint: "اسم المصدر",
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

                      await widget.sourceCubit.modifySource(ModifySourceParam(
                          sourceId: sourceId,
                          name: _nameController.text));

                      setState(() {
                        isModify = false;
                      });

                      Navigator.pop(context);
                    }

                  }, text: widget.sourceModel != null ? "عدل" : "أضف")),

                  if (widget.sourceModel != null && Constants.currentEmployee!.permissions.contains(AppStrings.deleteSources)) const Spacer(flex: 1 ,),

                  if (widget.sourceModel != null && Constants.currentEmployee!.permissions.contains(AppStrings.deleteSources)) Expanded(
                      flex: 4,
                      child: DefaultButtonWidget(onTap: () async {

                        final confirmDelete = await Constants.showConfirmDialog(context: context, msg: "هل تريد تأكيد الحذف؟");

                        if (confirmDelete) {
                          setState(() {
                            isModify = true;
                          });

                          await widget.sourceCubit.deleteSource(widget.sourceModel!.sourceId);

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