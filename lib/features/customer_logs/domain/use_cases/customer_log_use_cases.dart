import 'package:crm_flutter_project/features/customer_logs/data/models/customer_log_filters_model.dart';
import 'package:crm_flutter_project/features/customer_logs/domain/entities/customer_logs_data.dart';
import 'package:crm_flutter_project/features/customer_logs/domain/repositories/customer_log_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class CustomerLogUseCases {
  Future<Either<Failure, CustomerLogsData>> getAllCustomerLogsWithFilters(
      CustomerLogFiltersModel customerLogFiltersModel);
}

class CustomerLogUseCasesImpl implements CustomerLogUseCases {
  final CustomerLogRepository customerLogRepository;

  CustomerLogUseCasesImpl({required this.customerLogRepository});

  @override
  Future<Either<Failure, CustomerLogsData>> getAllCustomerLogsWithFilters(
      CustomerLogFiltersModel customerLogFiltersModel) {
    return customerLogRepository
        .getAllCustomerLogsWithFilters(customerLogFiltersModel);
  }
}
