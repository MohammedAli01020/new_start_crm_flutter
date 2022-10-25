import 'package:equatable/equatable.dart';
class Report extends Equatable {
  const Report({
    required this.employeeName,
    required this.type,
    required this.count,
  });

  final String employeeName;
  final String type;
  final int count;



  @override
  List<Object> get props => [employeeName, type, count];
}