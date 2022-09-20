import 'package:crm_flutter_project/features/global_reports/data/models/employee_assigns_report_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../use_cases/global_reports_use_cases.dart';

abstract class GlobalReportsRepository {
  Future<Either<Failure, List<EmployeeAssignsReportModel>>>
      fetchEmployeesAssignReport(
          FetchEmployeesAssignReportParam fetchEmployeesAssignReportParam);
}
