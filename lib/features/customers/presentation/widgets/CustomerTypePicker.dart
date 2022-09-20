import 'package:crm_flutter_project/core/utils/constants.dart';
import 'package:crm_flutter_project/core/utils/enums.dart';
import 'package:crm_flutter_project/core/widgets/custom_list_tile.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';

class CustomerTypePicker extends StatefulWidget {
  final String? customerTypes;
  final Function onSelectTypeCallback;

  const CustomerTypePicker(
      {Key? key, this.customerTypes, required this.onSelectTypeCallback})
      : super(key: key);

  @override
  State<CustomerTypePicker> createState() => _CustomerTypePickerState();
}

class _CustomerTypePickerState extends State<CustomerTypePicker> {
  String? currentSelectedType;

  @override
  void initState() {
    super.initState();
    currentSelectedType = widget.customerTypes;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500.0,
      // height: 500.0,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (Constants.currentEmployee!.permissions.contains(AppStrings.viewAllLeads))
              CustomListTile(title: "كل العملاء",
                  isSelected: currentSelectedType == null ||
                      currentSelectedType == CustomerTypes.ALL.name,
                  onTapCallback: () {
                    currentSelectedType = CustomerTypes.ALL.name;
                    setState(() {});
                    widget.onSelectTypeCallback(CustomerTypes.ALL.name);
                    Navigator.pop(context);
                  }),

            if (Constants.currentEmployee!.permissions.contains(AppStrings.viewMyAssignedLeads))
            CustomListTile(title: "المعينين لي",
                isSelected: currentSelectedType == CustomerTypes.ME.name,
                onTapCallback: () {
                  currentSelectedType = CustomerTypes.ME.name;
                  setState(() {});
                  widget.onSelectTypeCallback(CustomerTypes.ME.name);
                  Navigator.pop(context);
                }),


            if (Constants.currentEmployee!.permissions.contains(AppStrings.viewTeamLeads) &&
                Constants.currentEmployee?.teamId != null)
            CustomListTile(title: "فريقي",
                isSelected: currentSelectedType == CustomerTypes.TEAM.name,
                onTapCallback: () {
                  currentSelectedType = CustomerTypes.TEAM.name;
                  setState(() {});
                  widget.onSelectTypeCallback(CustomerTypes.TEAM.name);
                  Navigator.pop(context);
                }),



            if (Constants.currentEmployee!.permissions.contains(AppStrings.viewTeamLeads) &&
                Constants.currentEmployee!.permissions.contains(AppStrings.viewMyAssignedLeads) &&
                Constants.currentEmployee?.teamId != null)

            CustomListTile(title: "انا وفريقي",
                isSelected: currentSelectedType == CustomerTypes.ME_AND_TEAM.name,
                onTapCallback: () {
                  currentSelectedType = CustomerTypes.ME_AND_TEAM.name;
                  setState(() {});
                  widget.onSelectTypeCallback(CustomerTypes.ME_AND_TEAM.name);
                  Navigator.pop(context);
                }),

            if (Constants.currentEmployee!.permissions.contains(AppStrings.viewNotAssignedLeads))
              ListTile(
                onTap: () {
                  currentSelectedType = CustomerTypes.NOT_ASSIGNED.name;
                  setState(() {});
                  widget.onSelectTypeCallback(CustomerTypes.NOT_ASSIGNED.name);
                  Navigator.pop(context);
                },
                title: const Text("غير معينين"),
                selected:
                    currentSelectedType == CustomerTypes.NOT_ASSIGNED.name,
              ),

          ],
        ),
      ),
    );
  }
}
