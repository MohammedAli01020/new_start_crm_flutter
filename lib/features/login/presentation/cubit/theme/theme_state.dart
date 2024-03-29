part of 'theme_cubit.dart';

@immutable
abstract class ThemeState extends Equatable {
  final Locale? locale;

  const ThemeState({this.locale});
  @override
  List<Object?> get props => [locale];
}

class ThemeInitial extends ThemeState {}


class StartChangeThemeToDark extends ThemeState {}

class EndChangeThemeToDark extends ThemeState {}

class ChangeThemeToDarkError extends ThemeState {
  final String msg;

  const ChangeThemeToDarkError({required this.msg});

  @override
  List<Object> get props => [msg];

}


class StartChangeThemeToLight extends ThemeState {}

class EndChangeThemeToLight extends ThemeState {}

class ChangeThemeToLightError extends ThemeState {
  final String msg;

  const ChangeThemeToLightError({required this.msg});

  @override
  List<Object> get props => [msg];
}


class StartFetchCurrentTheme extends ThemeState {}

class EndFetchCurrentTheme extends ThemeState {
  final bool currentThemeMode;

  const EndFetchCurrentTheme({required this.currentThemeMode});


  @override
  List<Object> get props => [currentThemeMode];
}

class FetchCurrentThemeError extends ThemeState {
  final String msg;

  const FetchCurrentThemeError({required this.msg});

  @override
  List<Object> get props => [msg];
}

// lang
class ChangeLocaleState extends ThemeState {
  const ChangeLocaleState(Locale selectedLocale) : super(locale: selectedLocale);
}