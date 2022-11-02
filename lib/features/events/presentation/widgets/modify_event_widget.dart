import 'package:crm_flutter_project/features/events/domain/use_cases/events_use_cases.dart';
import 'package:crm_flutter_project/features/events/presentation/cubit/event_cubit.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/custom_edit_text.dart';
import '../../../../core/widgets/default_button_widget.dart';
import '../../../../core/widgets/default_hieght_sized_box.dart';
import '../../../customers/data/models/event_model.dart';

class ModifyEventWidget extends StatefulWidget {
  final EventModel? eventModel;
  final EventCubit eventCubit;
  final EventState state;

  const ModifyEventWidget({
    Key? key, this.eventModel,
    required this.eventCubit,
    required this.state,
  }) : super(key: key);

  @override
  State<ModifyEventWidget> createState() => _ModifyEventWidgetState();
}

class _ModifyEventWidgetState extends State<ModifyEventWidget> {
  final formKey = GlobalKey<FormState>();
  int? eventId;
  final _nameController = TextEditingController();

  bool isDescRequired = false;
  bool isDateRequired = false;


  @override
  void initState() {
    super.initState();
    if (widget.eventModel != null) {
      eventId = widget.eventModel!.eventId;
      _nameController.text = widget.eventModel!.name;
      isDescRequired = widget.eventModel!.isDescRequired;
      isDateRequired = widget.eventModel!.isDateRequired;
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
          child: isModify
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomEditText(
                        controller: _nameController,
                        hint: "اسم الحدث",
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

                    CheckboxListTile(
                        title: const Text("هل النص مطلوب"),
                        value: isDescRequired, onChanged: (val) {
                          if (val != null) {
                            isDescRequired = val;
                            setState(() {});
                          }

                    }),
                    const DefaultHeightSizedBox(),

                    CheckboxListTile(
                        title: const Text("هل التاريخ مطلوب"),
                        value: isDateRequired, onChanged: (val) {
                      if (val != null) {
                        isDateRequired = val;
                        setState(() {});
                      }

                    }),
                    const DefaultHeightSizedBox(),
                    const DefaultHeightSizedBox(),
                    Row(
                      children: [
                        Expanded(
                            flex: 4,
                            child: DefaultButtonWidget(
                                onTap: () async {
                                  if (formKey.currentState!.validate()) {
                                    setState(() {
                                      isModify = true;
                                    });

                                    await widget.eventCubit.modifyEvent(
                                        ModifyEventParam(
                                            eventId: eventId,
                                            name: _nameController.text,
                                            isDescRequired: isDescRequired,
                                            isDateRequired: isDateRequired));

                                    setState(() {
                                      isModify = false;
                                    });

                                    Navigator.pop(context);
                                  }
                                },
                                text: widget.eventModel != null ? "عدل" : "أضف")),
                        if (widget.eventModel != null && Constants.currentEmployee!.permissions.contains(AppStrings.deleteEvents))
                          const Spacer(
                            flex: 1,
                          ),
                        if (widget.eventModel != null && Constants.currentEmployee!.permissions.contains(AppStrings.deleteEvents))
                          Expanded(
                              flex: 4,
                              child: DefaultButtonWidget(
                                  onTap: () async {
                                    final confirmDelete =
                                        await Constants.showConfirmDialog(
                                            context: context,
                                            msg: "هل تريد تأكيد الحذف؟");

                                    if (confirmDelete) {
                                      setState(() {
                                        isModify = true;
                                      });

                                      await widget.eventCubit.deleteEvent(
                                          widget.eventModel!.eventId);

                                      setState(() {
                                        isModify = false;
                                      });

                                      Navigator.pop(context);
                                    }
                                  },
                                  text: "حذف")),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

