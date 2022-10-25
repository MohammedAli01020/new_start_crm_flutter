import 'package:equatable/equatable.dart';

import '../../data/models/report_model.dart';

class ReportData extends Equatable {
  const ReportData({
    required this.lastEventReport,
    required this.sourcesReport,
    required this.projectsReport,
    required this.unitTypesReport,
  });



  final Map<String, List<ReportModel>> lastEventReport;
  final Map<String, List<ReportModel>> sourcesReport;
  final Map<String, List<ReportModel>> projectsReport;
  final Map<String, List<ReportModel>> unitTypesReport;



  @override
  List<Object> get props =>
      [lastEventReport, sourcesReport, projectsReport, unitTypesReport,];
}

