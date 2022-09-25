import 'package:crm_flutter_project/core/error/failures.dart';
import 'package:crm_flutter_project/features/own_reports/data/data_sources/own_reports_remote_data_source.dart';
import 'package:crm_flutter_project/features/own_reports/data/models/count_customer_type_filters_model.dart';
import 'package:crm_flutter_project/features/own_reports/domain/entities/employee_statistics_result.dart';
import 'package:crm_flutter_project/features/own_reports/domain/repositories/own_reports_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';

class OwnReportsRepositoryImpl implements OwnReportsRepository{
  final OwnReportsRemoteDataSource ownReportsRemoteDataSource;

  OwnReportsRepositoryImpl({required this.ownReportsRemoteDataSource});

  @override
  Future<Either<Failure, EmployeeStatisticsResult>> fetchEmployeeReports(CountCustomerTypeFiltersModel countCustomerTypeFiltersModel) async {
    try {
      final response = await ownReportsRemoteDataSource.fetchEmployeeReports(countCustomerTypeFiltersModel);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }
  
}