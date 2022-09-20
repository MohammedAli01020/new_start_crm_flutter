part of 'global_reports_cubit.dart';

@immutable
abstract class GlobalReportsState extends Equatable {

  @override
  List<Object?> get props => [];
}

class GlobalReportsInitial extends GlobalReportsState {}

class StartUpdateFilter extends GlobalReportsState {}

class EndUpdateFilter extends GlobalReportsState {}

class StartResetFilter extends GlobalReportsState {}

class EndResetFilter extends GlobalReportsState {}


class StartFetchEmployeesAssignsReport extends GlobalReportsState {}

class EndFetchEmployeesAssignsReport extends GlobalReportsState {
  final List<EmployeeAssignsReportModel> newAssignsReports;

  EndFetchEmployeesAssignsReport({required this.newAssignsReports});

  @override
  List<Object> get props => [newAssignsReports];
}

class FetchEmployeesAssignsReportError extends GlobalReportsState {
  final String msg;

  FetchEmployeesAssignsReportError({required this.msg});

  @override
  List<Object> get props => [msg];


}
