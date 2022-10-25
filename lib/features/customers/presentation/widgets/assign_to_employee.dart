import 'package:crm_flutter_project/core/utils/app_strings.dart';
import 'package:crm_flutter_project/core/utils/constants.dart';
import 'package:flutter/material.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/enums.dart';
import '../../../employees/data/models/employee_response_model.dart';
import '../../../teams/presentation/cubit/team_members/team_members_cubit.dart';
import '../../../employees/presentation/screens/employee_picker_screen.dart';

class AssignToEmployee extends StatefulWidget {
  final TeamMembersCubit teamMembersCubit;
  final Function onAssignedCallback;
  final VoidCallback onRemoveCallback;
  final EmployeeResponseModel? currentEmployee;
  final bool? viewPreviousLog;

  const AssignToEmployee({Key? key,
    required this.teamMembersCubit,
    required this.onAssignedCallback,
    this.currentEmployee,
    required this.onRemoveCallback,

    required  this.viewPreviousLog}) : super(key: key);

  @override
  State<AssignToEmployee> createState() => _AssignToEmployeeState();
}

class _AssignToEmployeeState extends State<AssignToEmployee> {
  EmployeeResponseModel? employeeModel;
  bool? viewPreviousLog;
  @override
  void initState() {
    super.initState();
    employeeModel = widget.currentEmployee;
    viewPreviousLog = widget.viewPreviousLog;
  }



  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Card(
                child: ListTile(
                  onTap: () {

                    if (!Constants.currentEmployee!.permissions.contains(AppStrings.assignEmployees)) {
                      Constants.showToast(msg: "غير مصرح لك بتعيين موظفين", context: context);
                      return;
                    }


                    Navigator.pushNamed(context, Routes.employeePickerRoute,
                        arguments: EmployeePickerArgs(
                          teamMembersCubit: widget.teamMembersCubit,
                          employeePickerTypes: EmployeePickerTypes.ASSIGN_MEMBER.name,
                        )).then((value) {
                      if (value != null && value is Map<String, dynamic>) {
                        debugPrint(value.toString());
                        employeeModel =  EmployeeResponseModel.fromJson(value);
                        setState(() {

                        });

                        widget.onAssignedCallback(employeeModel, viewPreviousLog);
                      }

                    });
                  },
                  title: const Text("عينه الي موظف"),
                  subtitle: Text(employeeModel != null ? employeeModel!.fullName : "لم تختر موظف"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),

            if (employeeModel != null)
            IconButton(onPressed: () {

              employeeModel = null;
              setState(() {});
              widget.onRemoveCallback();
            }, icon: const Icon(Icons.delete))
          ],

        ),


        if (employeeModel != null)
          Card(
            child: CheckboxListTile(

                title: const Text("مشاهدة سجل العميل السابقة"),
                value: viewPreviousLog ?? true, onChanged: (val) {

              viewPreviousLog = val;
              setState(() {

              });
            }),
          ),

      ],
    );
  }
}