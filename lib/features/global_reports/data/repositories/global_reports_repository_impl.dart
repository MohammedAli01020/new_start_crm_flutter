import 'package:crm_flutter_project/core/error/failures.dart';
import 'package:crm_flutter_project/features/global_reports/data/data_sources/global_reports_remote_data_source.dart';
import 'package:crm_flutter_project/features/global_reports/data/models/employee_assigns_report_model.dart';
import 'package:crm_flutter_project/features/global_reports/domain/use_cases/global_reports_use_cases.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/global_reports_repository.dart';

class GlobalReportsRepositoryImpl implements GlobalReportsRepository {
  final GlobalReportsRemoteDataSource globalReportsRemoteDataSource;

  GlobalReportsRepositoryImpl({required this.globalReportsRemoteDataSource});

  @override
  Future<Either<Failure, List<EmployeeAssignsReportModel>>>
      fetchEmployeesAssignReport(
          FetchEmployeesAssignReportParam
              fetchEmployeesAssignReportParam) async {
    try {
      final response = await globalReportsRemoteDataSource
          .fetchEmployeesAssignReport(fetchEmployeesAssignReportParam);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }
}
