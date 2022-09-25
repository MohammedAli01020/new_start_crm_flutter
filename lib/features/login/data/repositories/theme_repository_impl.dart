import 'package:crm_flutter_project/core/error/failures.dart';
import 'package:crm_flutter_project/features/login/data/data_sources/theme_local_data_source.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/repositories/theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDataSource themeLocalDataSource;

  ThemeRepositoryImpl({required this.themeLocalDataSource});
  @override
  Future<Either<Failure, void>> changeThemeToDark() async {
    try {
      final response = await themeLocalDataSource.changeThemeToDark();
      Constants.isDark = true;

      return Right(response);
    } on CacheException catch (e) {
      return Left(CacheFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, void>> changeThemeToLight() async {
    try {
      final response = await themeLocalDataSource.changeThemeToLight();
      Constants.isDark = false;

      return Right(response);
    } on CacheException catch (e) {
      return Left(CacheFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, bool>> fetchCurrentTheme() async {
    try {
      final response = await themeLocalDataSource.fetchCurrentTheme();

      Constants.isDark = response;

      return Right(response);
    } on CacheException catch (e) {
      return Left(CacheFailure(msg: e.msg));
    }
  }

}