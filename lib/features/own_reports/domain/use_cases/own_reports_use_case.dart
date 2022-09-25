import 'package:crm_flutter_project/features/own_reports/data/models/count_customer_type_filters_model.dart';
import 'package:crm_flutter_project/features/own_reports/domain/entities/employee_statistics_result.dart';
import 'package:crm_flutter_project/features/own_reports/domain/repositories/own_reports_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class OwnReportsUseCase {
  Future<Either<Failure, EmployeeStatisticsResult>> fetchEmployeeReports(
      CountCustomerTypeFiltersModel countCustomerTypeFiltersModel);
}

class OwnReportsUseCaseImpl implements OwnReportsUseCase {
  final OwnReportsRepository ownReportsRepository;

  OwnReportsUseCaseImpl({required this.ownReportsRepository});

  @override
  Future<Either<Failure, EmployeeStatisticsResult>> fetchEmployeeReports(
      CountCustomerTypeFiltersModel countCustomerTypeFiltersModel) {
    return ownReportsRepository
        .fetchEmployeeReports(countCustomerTypeFiltersModel);
  }
}
