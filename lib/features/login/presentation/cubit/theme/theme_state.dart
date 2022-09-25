part of 'theme_cubit.dart';

@immutable
abstract class ThemeState extends Equatable {
  @override
  List<Object> get props => [];
}

class ThemeInitial extends ThemeState {}


class StartChangeThemeToDark extends ThemeState {}

class EndChangeThemeToDark extends ThemeState {}

class ChangeThemeToDarkError extends ThemeState {
  final String msg;

  ChangeThemeToDarkError({required this.msg});

  @override
  List<Object> get props => [msg];

}


class StartChangeThemeToLight extends ThemeState {}

class EndChangeThemeToLight extends ThemeState {}

class ChangeThemeToLightError extends ThemeState {
  final String msg;

  ChangeThemeToLightError({required this.msg});

  @override
  List<Object> get props => [msg];
}
