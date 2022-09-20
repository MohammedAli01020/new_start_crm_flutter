import 'package:equatable/equatable.dart';

class CustomerLogFilters extends Equatable {
  final int pageNumber;
  final int pageSize;
  final String sortDirection;
  final String sortBy;
  final int? customerId;
  final int? employeeId;
  final int? startDateTime;
  final int? endDateTime;

  const CustomerLogFilters({
    required this.pageNumber,
    required this.pageSize,
    required this.sortDirection,
    required this.sortBy,
    required this.customerId,
    required this.employeeId,
    required this.startDateTime,
    required this.endDateTime,
  });

  @override
  List<Object?> get props => [
        pageNumber,
        pageSize,
        sortDirection,
        sortBy,
        customerId,
        employeeId,
        startDateTime,
        endDateTime,
      ];
}
