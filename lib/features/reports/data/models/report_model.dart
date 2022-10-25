import '../../domain/entities/report.dart';

class ReportModel extends Report {
  const ReportModel({required String employeeName, required String type, required int count}) : super(employeeName: employeeName, type: type, count: count);

  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      ReportModel(
        employeeName: json["employeeName"],
        type: json["type"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() =>
      {
        "employeeName": employeeName,
        "type": type,
        "count": count,
      };
}