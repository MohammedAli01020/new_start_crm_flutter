import '../../domain/entities/emoployee_assign_reports.dart';

class EmployeeAssignsReportModel extends EmployeeAssignsReport {
  const EmployeeAssignsReportModel({required String fullName, required int count}) : super(fullName: fullName, count: count);

  factory EmployeeAssignsReportModel.fromJson(Map<String, dynamic> json) =>
      EmployeeAssignsReportModel(
        fullName: json["fullName"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() =>
      {
        "fullName": fullName,
        "count": count,
      };
  
}