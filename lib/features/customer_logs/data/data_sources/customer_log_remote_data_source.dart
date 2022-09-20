import 'package:crm_flutter_project/core/api/api_consumer.dart';
import 'package:crm_flutter_project/features/customer_logs/data/models/customerLogs_data_model.dart';
import '../../../../core/api/end_points.dart';
import '../models/customer_log_filters_model.dart';

abstract class CustomerLogRemoteDataSource {
  Future<CustomerLogsDataModel> getAllCustomerLogsWithFilters(
      CustomerLogFiltersModel customerLogFiltersModel);
}

class CustomerLogRemoteDataSourceImpl implements CustomerLogRemoteDataSource {
  final ApiConsumer apiConsumer;

  CustomerLogRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<CustomerLogsDataModel> getAllCustomerLogsWithFilters(
      CustomerLogFiltersModel customerLogFiltersModel) async {
    final response = await apiConsumer.get(EndPoints.pageCustomerLogs,
        queryParameters: customerLogFiltersModel.toJson());

    return CustomerLogsDataModel.fromJson(response);
  }
}
