import 'package:bloc/bloc.dart';
import 'package:crm_flutter_project/core/error/failures.dart';
import 'package:crm_flutter_project/core/utils/constants.dart';
import 'package:crm_flutter_project/features/login/domain/use_cases/theme_use_case.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final ThemeUseCase themeUseCase;
  ThemeCubit({required this.themeUseCase}) : super(ThemeInitial());


  Future<void> changeThemeToDark() async {
    emit(StartChangeThemeToDark());
    Either<Failure, void> response = await themeUseCase.changeThemeToDark();

    emit(response.fold((failure) => ChangeThemeToDarkError(msg: Constants.mapFailureToMsg(failure)),
            (r) => EndChangeThemeToDark()));
  }


 Future<void>  changeThemeToLight() async {
   emit(StartChangeThemeToLight());
   Either<Failure, void> response = await themeUseCase.changeThemeToLight();

   emit(response.fold((failure) => ChangeThemeToLightError(msg: Constants.mapFailureToMsg(failure)),
           (r) => EndChangeThemeToLight()));
 }


 void fetchCurrentTheme() {

 }
}
