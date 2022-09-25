import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class ThemeRepository {

  Future<Either<Failure, void>> changeThemeToLight();
  Future<Either<Failure, void>> changeThemeToDark();

  Future<Either<Failure, bool>> fetchCurrentTheme();
}