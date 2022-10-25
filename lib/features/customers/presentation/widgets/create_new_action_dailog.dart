
import 'package:crm_flutter_project/core/utils/constants.dart';
import 'package:crm_flutter_project/core/utils/enums.dart';
import 'package:crm_flutter_project/features/customers/data/models/last_action_model.dart';
import 'package:crm_flutter_project/features/customers/domain/use_cases/customer_use_cases.dart';
import 'package:crm_flutter_project/features/events/presentation/screens/events_screen.dart';
import 'package:flutter/material.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/custom_edit_text.dart';
import '../../../../core/widgets/default_hieght_sized_box.dart';
import '../../data/models/event_model.dart';

class CreateNewAction extends StatefulWidget {
  final LastActionModel? lastActionModel;
  final Function onConfirmAction;
  final int customerId;

  const CreateNewAction({
    Key? key,
    this.lastActionModel,
    required this.onConfirmAction,
    required this.customerId,
  }) : super(key: key);

  @override
  State<CreateNewAction> createState() => _CreateNewActionState();
}

class _CreateNewActionState extends State<CreateNewAction> {
  final formKey = GlobalKey<FormState>();

  final _actionDescriptionController = TextEditingController();
  int dateTime = DateTime.now().millisecondsSinceEpoch;
  int? postponeDateTime;

  EventModel? event;
  int lastActionByEmployeeId = Constants.currentEmployee!.employeeId;

  @override
  void initState() {
    super.initState();
    if (widget.lastActionModel != null) {

      // event = widget.lastActionModel!.event;
      // postponeDateTime = widget.lastActionModel!.postponeDateTime;
      // _actionDescriptionController.text =
      //     widget.lastActionModel!.actionDescription != null &&
      //             widget.lastActionModel!.actionDescription!.isNotEmpty
      //         ? widget.lastActionModel!.actionDescription!
      //         : "";

    }
  }

  void _resetData() {
    _actionDescriptionController.clear();
    event = null;
    postponeDateTime = null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              child: ListTile(
                onTap: () {
                  Navigator.pushNamed(context, Routes.eventsRoute,
                          arguments: EventsArgs(
                              eventType: EventType.SELECT_EVENT.name,
                              eventModel: event))
                      .then((value) {
                    if (value == null) {
                      event = null;
                    } else if (value is EventModel) {
                      event = value;
                    }
                    setState(() {});
                  });
                },
                title: Text(event != null ? "عدل الحدث" : "اختر الحدث"),
                subtitle: Text(event != null ? event!.name : "لا يوجد"),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
            const DefaultHeightSizedBox(),
            CustomEditText(
                controller: _actionDescriptionController,
                hint: "الوصف",
                validator: (v) {

                  if (v == null || v.isEmpty) {
                    return AppStrings.required;
                  }

                  if ( v.isNotEmpty) {
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
            Card(
              child: ListTile(
                onTap: () async {
                  final date = await showDatePicker(context: context,
                      initialDate: postponeDateTime != null ?
                      DateTime.fromMillisecondsSinceEpoch(postponeDateTime!) :
                      DateTime.now(),
                      firstDate: DateTime(DateTime.now().year - 5),
                      lastDate: DateTime(DateTime.now().year + 5));

                    if (date != null) {
                      postponeDateTime = date.millisecondsSinceEpoch;
                      setState(() {});

                      final time = await showTimePicker(context: context,
                          initialTime: TimeOfDay.fromDateTime(date));

                        if (time != null) {
                          final d = date.add(Duration(hours: time.hour, minutes: time.minute));
                          postponeDateTime = d.millisecondsSinceEpoch;
                          setState(() {});
                        }
                    }





                },
                title: const Text("حدد معاد التذكير"),
                subtitle: Text(Constants.dateTimeFromMilliSeconds(postponeDateTime)),
                trailing: postponeDateTime != null ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    postponeDateTime = null;
                    setState(() {});
                  },
                ) : null ,
              ),
            ),
            const DefaultHeightSizedBox(),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (event == null) {
                        Constants.showToast(
                            msg: "يجب اختيار الحدث", context: context);
                        return;
                      }

                      widget.onConfirmAction(UpdateCustomerLastActionParam(
                          customerId: widget.customerId,
                          dateTime: dateTime,
                          postponeDateTime: postponeDateTime,
                          eventId: event!.eventId,
                          lastActionByEmployeeId: lastActionByEmployeeId,
                          actionDescription: _actionDescriptionController.text));
                    }
                  },
                  style: TextButton.styleFrom(
                      primary: Colors.black,
                      textStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  child: const Text('تأكيد'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: TextButton.styleFrom(
                      primary: Colors.black,
                      textStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  child: const Text('إلغاء'),
                ),
                TextButton(
                  onPressed: () {
                    _resetData();
                    setState(() {});
                  },
                  style: TextButton.styleFrom(
                      primary: Colors.red,
                      textStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  child: const Text('مسح الكل'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

