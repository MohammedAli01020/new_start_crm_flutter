import 'package:equatable/equatable.dart';
class EmployeeResponse extends Equatable {
  const EmployeeResponse({
    required this.employeeId,
    required this.fullName,
    required this.imageUrl,
  });

  final int employeeId;
  final String fullName;
  final String? imageUrl;

  @override
  List<Object?> get props => [
    employeeId,
    fullName,
    imageUrl,
  ];
}