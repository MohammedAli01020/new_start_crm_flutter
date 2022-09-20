import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/customer_log_filters_model.dart';
import '../entities/customer_logs_data.dart';

abstract class CustomerLogRepository {
  Future<Either<Failure, CustomerLogsData>> getAllCustomerLogsWithFilters(

      CustomerLogFiltersModel customerLogFiltersModel);
}