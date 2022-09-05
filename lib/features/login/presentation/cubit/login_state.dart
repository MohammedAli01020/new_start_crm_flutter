part of 'login_cubit.dart';

@immutable
abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class StartLogin extends LoginState {}

class EndLogin extends LoginState {
  final CurrentEmployee currentEmployee;

  EndLogin({required this.currentEmployee});

  @override
  List<Object> get props => [currentEmployee];
}

class LoginError extends LoginState {
  final String msg;

  LoginError({required this.msg});

  @override
  List<Object> get props => [msg];

}

class EmployeeIsNotEnabled extends LoginState {
  final String msg;

  EmployeeIsNotEnabled({required this.msg});

  @override
  List<Object> get props => [msg];
}



class StartInit extends LoginState {}

class NoCachedEmployeeFound extends LoginState {
  final String msg;

  NoCachedEmployeeFound({required this.msg});

  @override
  List<Object> get props => [msg];
}

class GettingEmployeeError extends LoginState {
  final String msg;

  GettingEmployeeError({required this.msg});

  @override
  List<Object> get props => [msg];
}

class EndInit extends LoginState {

}



class StartLogout extends LoginState {}
class EndLogout extends LoginState {}
class LogoutError extends LoginState {
  final String msg;

  LogoutError({required this.msg});

  @override
  List<Object> get props => [msg];
}
