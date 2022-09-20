import 'package:equatable/equatable.dart';

class EmployeeAssignsReport extends Equatable {
  final String fullName;
  final int count;

  const EmployeeAssignsReport({required this.fullName, required this.count});

  @override
  List<Object> get props => [fullName, count];
}
