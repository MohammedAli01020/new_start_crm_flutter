import 'dart:convert';

import '../../../../core/utils/app_strings.dart';
import '../../../customer_table_config/data/models/customer_table_config_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
abstract class CustomerLocalDataSource {
  Future<void> cacheCustomerTableConfig(CustomerTableConfigModel customerTableConfigModel);
}

class CustomerLocalDataSourceImpl implements CustomerLocalDataSource {
  final SharedPreferences sharedPreferences;

  CustomerLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheCustomerTableConfig(CustomerTableConfigModel customerTableConfigModel) {
    return sharedPreferences.setString(
        AppStrings.cachedCustomerTableConfig, json.encode(customerTableConfigModel));
  }
}