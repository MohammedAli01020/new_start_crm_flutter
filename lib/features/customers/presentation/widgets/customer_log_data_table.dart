import 'package:flutter/material.dart';

import '../../../../core/utils/constants.dart';
import '../../../customer_logs/presentation/cubit/customer_logs_cubit.dart';

class CustomerLogsDataTable extends DataTableSource {
  final CustomerLogsCubit customerLogsCubit;
  final Function onSelect;

  CustomerLogsDataTable({
    required this.customerLogsCubit,
    required this.onSelect,
  });

  @override
  DataRow? getRow(int index) {

    try {
      final currentCustomerLog = customerLogsCubit.customerLogs[index];
      return DataRow.byIndex(
          index: index,
          onSelectChanged: (val) {
            onSelect(val, currentCustomerLog);
          },
          cells: [
            DataCell(SizedBox(
              width: 300.0,
              child: Text(
                currentCustomerLog.description.toString(),
                maxLines: 3,
              ),
            )),
            DataCell(
                Text(Constants.timeAgoSinceDate(currentCustomerLog.dateTime))),
          ]);
    } catch(e) {
      return null;
    }

  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => customerLogsCubit.customerLogTotalElements;

  @override
  int get selectedRowCount => 0;
}