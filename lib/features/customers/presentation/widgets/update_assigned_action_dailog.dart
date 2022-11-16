
import 'package:crm_flutter_project/core/utils/constants.dart';
import 'package:crm_flutter_project/core/utils/enums.dart';
import 'package:crm_flutter_project/features/customers/data/models/last_action_model.dart';
import 'package:crm_flutter_project/features/customers/domain/use_cases/customer_use_cases.dart';
import 'package:crm_flutter_project/features/customers/presentation/cubit/customer_cubit.dart';
import 'package:crm_flutter_project/features/employees/data/models/employee_response_model.dart';
import 'package:crm_flutter_project/features/events/presentation/screens/events_screen.dart';
import 'package:crm_flutter_project/features/teams/presentation/cubit/team_members/team_members_cubit.dart';
import 'package:flutter/material.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/custom_edit_text.dart';
import '../../../../core/widgets/default_hieght_sized_box.dart';
import '../../../employees/data/models/employee_model.dart';
import '../../../employees/presentation/screens/employee_picker_screen.dart';
import '../../data/models/event_model.dart';

class UpdateAssignedAction extends StatefulWidget {
  final CustomerCubit customerCubit;
  final bool? viewPreviousLog;
  final TeamMembersCubit teamMembersCubit;
  final EmployeeResponseModel? assignedEmployee;

  const UpdateAssignedAction({
    Key? key,
    required this.customerCubit,
    this.assignedEmployee,
    required this.teamMembersCubit,
    this.viewPreviousLog,
  }) : super(key: key);

  @override
  State<UpdateAssignedAction> createState() => _UpdateAssignedActionState();
}

class _UpdateAssignedActionState extends State<UpdateAssignedAction> {
  final formKey = GlobalKey<FormState>();

  String? assignedEmployeeName;
  int? assignedEmployeeId;
  bool? viewPreviousLog = true;
  @override
  void initState() {
    super.initState();
    if (widget.assignedEmployee != null) {
      assignedEmployeeName = widget.assignedEmployee?.fullName;
      viewPreviousLog =  widget.viewPreviousLog;
      assignedEmployeeId =  widget.assignedEmployee?.employeeId;
    }
  }

  void _resetData() {
    assignedEmployeeName = null;
    viewPreviousLog = false;
    assignedEmployeeId = null;
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
                onTap: () async {


                  final pickedEmployee = await Navigator.pushNamed(
                      context, Routes.employeePickerRoute,
                      arguments: EmployeePickerArgs(
                        teamMembersCubit: widget.teamMembersCubit,
                        employeePickerTypes: EmployeePickerTypes
                            .ASSIGN_MEMBER.name,
                      ));
                  if (pickedEmployee != null &&
                      pickedEmployee is Map<String, dynamic>) {
                    final assignedEmployee = EmployeeModel
                        .fromJson(pickedEmployee);

                    assignedEmployeeId = assignedEmployee.employeeId;
                    assignedEmployeeName = assignedEmployee.fullName;
                    setState(() {});


                  }

                },
                title: Text(assignedEmployeeName != null ? "عدل الموظف" : "اختر الموظف"),
                subtitle: Text(assignedEmployeeName != null ? assignedEmployeeName! : "لا يوجد"),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
            const DefaultHeightSizedBox(),
            Card(
              child: CheckboxListTile(

                  title: const Text("مشاهدة سجل العميل السابقة"),
                  value: viewPreviousLog ?? true, onChanged: (val) {

                viewPreviousLog = val;
                setState(() {

                });
              }),
            ),

            const DefaultHeightSizedBox(),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (assignedEmployeeId == null ) {
                        Constants.showToast(msg: "يجب اختيار الموظف", context: context);
                        return;
                      }

                      if (viewPreviousLog == null ) {
                        Constants.showToast(msg: "يجب تحدد مشاهدة السجلات ام لا", context: context);
                        return;
                      }

                      widget.customerCubit.updateCustomerAssignedEmployee(
                          UpdateCustomerAssignedEmployeeParam(
                              updatedByEmployeeId: Constants
                                  .currentEmployee!.employeeId,
                              customerId: widget.customerCubit.currentCustomer
                                  .customerId,
                              assignedEmployee: assignedEmployeeId!,

                              viewPreviousLog: viewPreviousLog!));

                      Navigator.pop(context);
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

