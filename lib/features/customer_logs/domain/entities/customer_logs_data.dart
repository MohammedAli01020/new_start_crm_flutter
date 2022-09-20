import 'package:crm_flutter_project/features/customer_logs/data/models/customer_log_model.dart';
import 'package:crm_flutter_project/features/employees/data/models/pageable_model.dart';
import 'package:crm_flutter_project/features/employees/data/models/sort_model.dart';
import 'package:equatable/equatable.dart';

class CustomerLogsData extends Equatable {
  const CustomerLogsData({
    required this.customerLogs,
    required this.pageable,
    required this.last,
    required this.totalElements,
    required this.totalPages,
    required this.size,
    required this.number,
    required this.sort,
    required this.first,
    required this.numberOfElements,
    required this.empty,
  });

  final List<CustomerLogModel> customerLogs;
  final PageableModel pageable;
  final bool last;
  final int totalElements;
  final int totalPages;
  final int size;
  final int number;
  final SortModel sort;
  final bool first;
  final int numberOfElements;
  final bool empty;


  @override
  List<Object> get props =>
      [
        customerLogs,
        pageable,
        last,
        totalElements,
        totalPages,
        size,
        number,
        sort,
        first,
        numberOfElements,
        empty,
      ];
}


