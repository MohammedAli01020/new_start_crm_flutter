import 'package:crm_flutter_project/core/error/failures.dart';
import 'package:crm_flutter_project/features/customer_logs/data/data_sources/customer_log_remote_data_source.dart';

import 'package:crm_flutter_project/features/customer_logs/data/models/customer_log_filters_model.dart';

import 'package:crm_flutter_project/features/customer_logs/domain/entities/customer_logs_data.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/customer_log_repository.dart';

class CustomerLogRepositoryImpl implements CustomerLogRepository {
  final CustomerLogRemoteDataSource customerLogRemoteDataSource;

  CustomerLogRepositoryImpl({required this.customerLogRemoteDataSource});
  @override
  Future<Either<Failure, CustomerLogsData>> getAllCustomerLogsWithFilters(CustomerLogFiltersModel customerLogFiltersModel) async {
    try {
      final response = await customerLogRemoteDataSource.getAllCustomerLogsWithFilters(customerLogFiltersModel);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

}