import 'dart:convert';

import 'package:crm_flutter_project/features/login/data/models/current_employee_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../../../customer_table_config/data/models/customer_table_config_model.dart';
import '../../../../core/utils/app_strings.dart';
import '../../domain/entities/current_employee.dart';


abstract class LoginLocalDataSource {
  Future<void> cacheCurrentEmployee(CurrentEmployee currentEmployee);

  Future<CurrentEmployeeModel> getCacheEmployee();

  Future<void> removeCacheCurrentEmployee();

  Future<CustomerTableConfigModel> loadLastCustomerTableConfig();
}

class LoginLocalDataSourceImpl implements LoginLocalDataSource {
  final SharedPreferences sharedPreferences;

  LoginLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheCurrentEmployee(CurrentEmployee currentEmployee) {
    return sharedPreferences.setString(
        AppStrings.cachedCurrentEmployee, json.encode(currentEmployee));
  }

  @override
  Future<CurrentEmployeeModel> getCacheEmployee() {
    final response =
        sharedPreferences.getString(AppStrings.cachedCurrentEmployee);
    if (response != null) {
      try {
        final cacheCurrentEmployee =
            Future.value(CurrentEmployeeModel.fromJson(json.decode(response)));
        return cacheCurrentEmployee;
      } catch (e) {

        throw CacheException();
      }
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> removeCacheCurrentEmployee() {
    return sharedPreferences.remove(AppStrings.cachedCurrentEmployee);
  }

  @override
  Future<CustomerTableConfigModel> loadLastCustomerTableConfig() {
    final response =
    sharedPreferences.getString(AppStrings.cachedCustomerTableConfig);
    if (response != null) {
      try {
        final cacheCustomerTableConfig =
        Future.value(CustomerTableConfigModel.fromJson(json.decode(response)));
        return cacheCustomerTableConfig;
      } catch (e) {


        throw CacheException();
      }
    } else {
      throw CacheException();
    }
  }
}
