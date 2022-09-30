import 'package:flutter/material.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/default_user_avatar_widget.dart';
import '../cubit/employee_cubit.dart';

class EmployeesDataTable extends DataTableSource {
  final EmployeeCubit employeeCubit;
  final Function onSelect;

  EmployeesDataTable({
    required this.employeeCubit,
    required this.onSelect,
  });

  @override
  DataRow? getRow(int index) {

    try {
      final currentEmployee = employeeCubit.employees[index];

      return DataRow.byIndex(
          index: index,
          onSelectChanged: (val) {
            onSelect(val, currentEmployee);
          },
          cells: [
            DataCell(DefaultUserAvatarWidget(
              imageUrl: currentEmployee.imageUrl,
              fullName: currentEmployee.fullName,
              height: 40.0,)),

            DataCell(Text(currentEmployee.fullName)),
            DataCell(Text(Constants.dateTimeFromMilliSeconds(
                currentEmployee.createDateTime))),
            DataCell(TextButton(
                onPressed: () {
                  Constants.launchCallerV2(currentEmployee.phoneNumber);
                },
                child: Text(currentEmployee.phoneNumber))),

            DataCell(Text(currentEmployee.enabled.toString())),
            DataCell(Text(currentEmployee.username)),
          ]);
    } catch(e) {
      return null;
    }

  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => employeeCubit.employeeTotalElements;

  @override
  int get selectedRowCount => 0;
}