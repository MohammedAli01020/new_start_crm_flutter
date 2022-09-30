import 'package:crm_flutter_project/features/login/domain/repositories/theme_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class ThemeUseCase {

  Future<Either<Failure, void>> changeThemeToLight();
  Future<Either<Failure, void>> changeThemeToDark();

  Future<Either<Failure, bool>> fetchCurrentTheme();

}

class ThemeUseCaseImpl implements ThemeUseCase {
  final ThemeRepository themeRepository;

  ThemeUseCaseImpl({required this.themeRepository});
  @override
  Future<Either<Failure, void>> changeThemeToDark() {

    return themeRepository.changeThemeToDark();
  }

  @override
  Future<Either<Failure, void>> changeThemeToLight() {

    return themeRepository.changeThemeToLight();
  }

  @override
  Future<Either<Failure, bool>> fetchCurrentTheme() {
    return themeRepository.fetchCurrentTheme();

  }

}