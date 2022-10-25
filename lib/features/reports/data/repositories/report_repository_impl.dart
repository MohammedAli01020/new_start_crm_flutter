import 'package:crm_flutter_project/core/error/failures.dart';

import 'package:crm_flutter_project/features/reports/data/models/report_data_model.dart';

import 'package:crm_flutter_project/features/reports/domain/use_cases/report_use_cases.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/report_repository.dart';
import '../data_sources/report_remote_data_source.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource reportRemoteDataSource;

  ReportRepositoryImpl({required this.reportRemoteDataSource});


  @override
  Future<Either<Failure, ReportDataModel>> fetchEmployeeCustomerReports(FetchEmployeesCustomerReportParam fetchEmployeesCustomerReportParam) async {
    try {
      final response = await reportRemoteDataSource.fetchEmployeeCustomerReports(fetchEmployeesCustomerReportParam);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

}