import 'package:crm_flutter_project/core/utils/date_values.dart';
import 'package:crm_flutter_project/features/global_reports/data/models/employee_assigns_report_model.dart';
import 'package:crm_flutter_project/features/global_reports/domain/repositories/global_reports_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/wrapper.dart';

abstract class GlobalReportsUseCases {
  Future<Either<Failure, List<EmployeeAssignsReportModel>>>
      fetchEmployeesAssignReport(
          FetchEmployeesAssignReportParam fetchEmployeesAssignReportParam);
}

class GlobalReportsUseCasesImpl implements GlobalReportsUseCases {
  final GlobalReportsRepository globalReportsRepository;

  GlobalReportsUseCasesImpl({required this.globalReportsRepository});

  @override
  Future<Either<Failure, List<EmployeeAssignsReportModel>>>
      fetchEmployeesAssignReport(
          FetchEmployeesAssignReportParam fetchEmployeesAssignReportParam) {
    return globalReportsRepository
        .fetchEmployeesAssignReport(fetchEmployeesAssignReportParam);
  }
}

class FetchEmployeesAssignReportParam extends Equatable {
  final int? startDate;
  final int? endDate;

  const FetchEmployeesAssignReportParam(
      {required this.startDate, required this.endDate});

  Map<String, dynamic> toJson() => {"startDate": startDate, "endDate": endDate};

  FetchEmployeesAssignReportParam copyWith({
    Wrapped<int?>? startDate,
    Wrapped<int?>? endDate,
  }) {
    return FetchEmployeesAssignReportParam(
      startDate: startDate != null ? startDate.value : this.startDate,
      endDate: endDate != null ? endDate.value : this.endDate,
    );
  }

  factory FetchEmployeesAssignReportParam.initial() {
    return  FetchEmployeesAssignReportParam(
      startDate: DateTime.now().firstTimOfCurrentDayMillis,
      endDate: DateTime.now().lastTimOfCurrentDayMillis,
    );
  }

  @override
  List<Object?> get props => [startDate, endDate];
}
