import 'package:crm_flutter_project/features/unit_types/presentation/screens/unit_types_screen.dart';
import 'package:flutter/material.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/widgets/default_hieght_sized_box.dart';
import '../../../employees/data/models/employee_model.dart';
import '../../../sources/presentation/screens/sources_screen.dart';
import '../../../teams/presentation/cubit/team_members/team_members_cubit.dart';
import '../../../employees/presentation/screens/employee_picker_screen.dart';
import '../../domain/use_cases/customer_use_cases.dart';

class BulkActionsWidget extends StatefulWidget {
  final Function onConfirmAction;
  final List<int> selectedCustomersIds;
  final TeamMembersCubit teamMembersCubit;

  const BulkActionsWidget(
      {Key? key,
        required this.onConfirmAction,
        required this.selectedCustomersIds,
        required this.teamMembersCubit})
      : super(key: key);

  @override
  State<BulkActionsWidget> createState() => _BulkActionsWidgetState();
}

class _BulkActionsWidgetState extends State<BulkActionsWidget> {

  List<String>? sourcesNames;
  List<String>? unitTypesNames;
  EmployeeModel? assignedToEmployee;

  bool? viewPreviousLog = true;


  void _resetData() {
    sourcesNames = null;
    unitTypesNames = null;
    assignedToEmployee = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        if (Constants.currentEmployee!.permissions.contains(AppStrings.assignEmployees) ||
        ( Constants.currentEmployee!.permissions.contains(AppStrings.assignMyTeamMembers) &&
            Constants.currentEmployee?.teamId != null))
        Row(
          children: [
            Expanded(
              child: Card(
                child:ListTile(
                  onTap: () {

                    Navigator.pushNamed(context, Routes.employeePickerRoute,
                        arguments: EmployeePickerArgs(
                          teamMembersCubit: widget.teamMembersCubit,
                          employeePickerTypes: Constants.currentEmployee!.permissions.contains(AppStrings.assignEmployees) ?

                          EmployeePickerTypes.ASSIGN_MEMBER.name : EmployeePickerTypes.ASSIGN_FROM_TEAM_MEMBERS.name,
                        )).then((value) {

                      if (value != null && value is Map<String, dynamic>) {
                        debugPrint(value.toString());
                        assignedToEmployee = EmployeeModel.fromJson(value);
                      }

                      setState(() {});
                    });
                  },
                  title: const Text("اختر الموظف"),
                  subtitle: Text(assignedToEmployee != null
                      ? assignedToEmployee!.fullName
                      : "اختر"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
            if (assignedToEmployee != null)
              IconButton(onPressed: () {

                assignedToEmployee = null;
                setState(() {});
              }, icon: const Icon(Icons.delete))
          ],
        ),


        if (assignedToEmployee != null)
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
        if (Constants.currentEmployee!.permissions.contains(AppStrings.bulkActions))
        Card(
          child: ListTile(
            onTap: () async {

              final pickedSources = await Navigator.pushNamed(context, Routes.sourcesRoute,
                  arguments: SourcesArgs(sourceType: SourceType.SELECT_SOURCES.name,
                      selectedSourcesNames: sourcesNames ?? []));

              if (pickedSources != null && pickedSources is List<String>) {

                sourcesNames = pickedSources;

                setState(() {
                });
              }

            },
            title: const Text("اختر المصادر"),
            subtitle: Text(sourcesNames != null ? sourcesNames.toString() : "لم تختر اي مصدر",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ),
        const DefaultHeightSizedBox(),
        if (Constants.currentEmployee!.permissions.contains(AppStrings.bulkActions))

        Card(
          child: ListTile(
            onTap: () async {
              final pickedUnitTypes = await Navigator.pushNamed(context, Routes.unitTypesRoute,
                  arguments: UnitTypesArgs(unitTypesType: UnitTypesType.SELECT_UNIT_TYPES.name,
                      selectedUnitTypesNames: unitTypesNames ?? [] ));

              if (pickedUnitTypes != null && pickedUnitTypes is List<String>) {

                unitTypesNames = pickedUnitTypes;

                setState(() {
                });
              }
            },
            title: const Text("اختر الاهتامات"),
            subtitle: Text(unitTypesNames != null ? unitTypesNames.toString() : "لم تختر اي عنصر",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ),
        const DefaultHeightSizedBox(),
        Row(
          children: [
            TextButton(
              onPressed: () {
                if (sourcesNames == null &&
                    unitTypesNames == null &&
                    assignedToEmployee == null) {
                  Constants.showToast(msg: "لا يوجد اي تغير", context: context);
                  return;
                }

                widget.onConfirmAction(UpdateCustomerParam(
                    assignedByEmployeeId: Constants.currentEmployee?.employeeId,
                    sources: sourcesNames,
                    unitTypes: unitTypesNames,
                    customerIds: widget.selectedCustomersIds,
                    assignedToEmployeeId: assignedToEmployee?.employeeId,
                    viewPreviousLog: assignedToEmployee != null ?  viewPreviousLog : null));
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
    );
  }
}