part of 'own_reports_cubit.dart';

@immutable
abstract class OwnReportsState extends Equatable{
  @override
  List<Object?> get props => [];
}

class OwnReportsInitial extends OwnReportsState {}


class StartFetchEmployeeReports extends OwnReportsState {}

class EndFetchEmployeeReports extends OwnReportsState {
  final EmployeeStatisticsResult employeeStatisticsResult;

  EndFetchEmployeeReports({required this.employeeStatisticsResult});
}

class FetchEmployeeReportsError extends OwnReportsState {

  final String msg;
  FetchEmployeeReportsError({required this.msg});

  @override
  List<Object> get props => [msg];
}



class StartUpdateFilter extends OwnReportsState {}

class EndUpdateFilter extends OwnReportsState {}


class StartSetSelectedEmployee extends OwnReportsState {}
class EndSetSelectedEmployee extends OwnReportsState {}