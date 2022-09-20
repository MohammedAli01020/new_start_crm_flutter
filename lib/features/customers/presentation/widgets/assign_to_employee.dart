import 'package:crm_flutter_project/core/utils/app_strings.dart';
import 'package:crm_flutter_project/core/utils/constants.dart';
import 'package:flutter/material.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/enums.dart';
import '../../../employees/data/models/employee_model.dart';
import '../../../teams/presentation/cubit/team_members/team_members_cubit.dart';
import '../../../teams/presentation/screens/employee_picker_screen.dart';

class AssignToEmployee extends StatefulWidget {
  final TeamMembersCubit teamMembersCubit;
  final Function onAssignedCallback;
  final EmployeeModel? currentEmployee;
  const AssignToEmployee({Key? key,
    required this.teamMembersCubit,
    required this.onAssignedCallback,
    this.currentEmployee}) : super(key: key);

  @override
  State<AssignToEmployee> createState() => _AssignToEmployeeState();
}

class _AssignToEmployeeState extends State<AssignToEmployee> {
  EmployeeModel? employeeModel;

  @override
  void initState() {
    super.initState();
    employeeModel = widget.currentEmployee;
  }



  @override
  Widget build(BuildContext context) {
    return  Card(
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
              employeeModel =  EmployeeModel.fromJson(value);
              setState(() {

              });

              widget.onAssignedCallback(employeeModel);
            }

          });
        },
        title: const Text("عينه الي موظف"),
        subtitle: Text(employeeModel != null ? employeeModel!.fullName : "لم تختر موظف"),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}