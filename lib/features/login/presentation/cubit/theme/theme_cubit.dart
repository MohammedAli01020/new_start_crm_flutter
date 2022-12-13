import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crm_flutter_project/core/error/failures.dart';
import 'package:crm_flutter_project/core/utils/constants.dart';
import 'package:crm_flutter_project/features/login/domain/use_cases/theme_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/utils/app_strings.dart';
import '../../../domain/use_cases/lang_use_cases.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final ThemeUseCase themeUseCase;
  final LangUseCases langUseCases;

  ThemeCubit({required this.themeUseCase, required this.langUseCases})
      : super(const ChangeLocaleState(Locale(AppStrings.arabicCode)));

  static ThemeCubit get(context) => BlocProvider.of(context);

  Future<void> changeThemeToDark() async {
    emit(StartChangeThemeToDark());
    Either<Failure, void> response = await themeUseCase.changeThemeToDark();

    emit(response.fold(
        (failure) =>
            ChangeThemeToDarkError(msg: Constants.mapFailureToMsg(failure)),
        (r) => EndChangeThemeToDark()));
  }

  Future<void> changeThemeToLight() async {
    emit(StartChangeThemeToLight());
    Either<Failure, void> response = await themeUseCase.changeThemeToLight();

    emit(response.fold(
        (failure) =>
            ChangeThemeToLightError(msg: Constants.mapFailureToMsg(failure)),
        (r) => EndChangeThemeToLight()));
  }

  Future<void> fetchCurrentTheme() async {
    emit(StartFetchCurrentTheme());
    Either<Failure, bool> response = await themeUseCase.fetchCurrentTheme();

    emit(response.fold(
        (failure) =>
            FetchCurrentThemeError(msg: Constants.mapFailureToMsg(failure)),
        (value) => EndFetchCurrentTheme(currentThemeMode: value)));
  }

  // lang
  String currentLangCode = AppStrings.arabicCode;

  Future<void> getSavedLang() async {
    final response = await langUseCases.getSavedLang();
    response.fold((failure) => debugPrint(AppStrings.cacheFailure), (value) {
      currentLangCode = value;
      emit(ChangeLocaleState(Locale(currentLangCode)));
    });
  }

  Future<void> _changeLang(String langCode) async {
    final response = await langUseCases.changeLang(langCode);

    response.fold((failure) => debugPrint(AppStrings.cacheFailure), (value) {
      currentLangCode = langCode;
      emit(ChangeLocaleState(Locale(currentLangCode)));
    });
  }

  void toEnglish() => _changeLang(AppStrings.englishCode);

  void toArabic() => _changeLang(AppStrings.arabicCode);
}
