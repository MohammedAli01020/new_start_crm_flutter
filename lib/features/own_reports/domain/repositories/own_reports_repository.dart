import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/count_customer_type_filters_model.dart';
import '../entities/employee_statistics_result.dart';

abstract class OwnReportsRepository {
  Future<Either<Failure, EmployeeStatisticsResult>> fetchEmployeeReports(
      CountCustomerTypeFiltersModel countCustomerTypeFiltersModel);
}