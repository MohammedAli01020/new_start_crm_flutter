import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/app_strings.dart';
abstract class ThemeLocalDataSource {
  Future<void> changeThemeToLight();
  Future<void> changeThemeToDark();

  Future<bool> fetchCurrentTheme();
}

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  final SharedPreferences sharedPreferences;

  ThemeLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> changeThemeToDark() {
    return sharedPreferences.setBool(
        AppStrings.cachedThemeMode, true);
  }

  @override
  Future<void> changeThemeToLight() {
    return sharedPreferences.setBool(
        AppStrings.cachedThemeMode, false);
  }

  @override
  Future<bool> fetchCurrentTheme() {
    final response =
    sharedPreferences.getBool(AppStrings.cachedThemeMode);
    if (response != null) {
      try {
        return Future.value(response);

      } catch (e) {

        throw CacheException();
      }
    } else {
      throw CacheException();
    }
  }


}