import '../../domain/entities/report_data.dart';
import '../../data/models/report_model.dart';

class ReportDataModel extends ReportData {
  const ReportDataModel(
      {required Map<String, List<ReportModel>> lastEventReport,
      required Map<String, List<ReportModel>> sourcesReport,
      required Map<String, List<ReportModel>> projectsReport,
      required Map<String, List<ReportModel>> unitTypesReport})
      : super(
            lastEventReport: lastEventReport,
            sourcesReport: sourcesReport,
            projectsReport: projectsReport,
            unitTypesReport: unitTypesReport);

  factory ReportDataModel.fromJson(Map<String, dynamic> json) =>
      ReportDataModel(
        lastEventReport: Map.from(json["lastEventReport"]).map((k, v) =>
            MapEntry<String, List<ReportModel>>(k,
                List<ReportModel>.from(v.map((x) => ReportModel.fromJson(x))))),
        sourcesReport: Map.from(json["sourcesReport"]).map((k, v) =>
            MapEntry<String, List<ReportModel>>(k,
                List<ReportModel>.from(v.map((x) => ReportModel.fromJson(x))))),
        projectsReport: Map.from(json["projectsReport"]).map((k, v) =>
            MapEntry<String, List<ReportModel>>(k,
                List<ReportModel>.from(v.map((x) => ReportModel.fromJson(x))))),
        unitTypesReport: Map.from(json["unitTypesReport"]).map((k, v) =>
            MapEntry<String, List<ReportModel>>(k,
                List<ReportModel>.from(v.map((x) => ReportModel.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "lastEventReport": Map.from(lastEventReport).map((k, v) =>
            MapEntry<String, dynamic>(
                k, List<dynamic>.from(v.map((x) => x.toJson())))),
        "sourcesReport": Map.from(sourcesReport).map((k, v) =>
            MapEntry<String, dynamic>(
                k, List<dynamic>.from(v.map((x) => x.toJson())))),
        "projectsReport": Map.from(projectsReport).map((k, v) =>
            MapEntry<String, dynamic>(
                k, List<dynamic>.from(v.map((x) => x.toJson())))),
        "unitTypesReport": Map.from(unitTypesReport).map((k, v) =>
            MapEntry<String, dynamic>(
                k, List<dynamic>.from(v.map((x) => x.toJson())))),
      };
}
