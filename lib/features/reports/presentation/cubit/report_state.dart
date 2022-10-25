part of 'report_cubit.dart';

@immutable
abstract class ReportState extends Equatable {
  @override
  List<Object> get props => [];
}

class ReportInitial extends ReportState {}


class StartFetchEmployeeCustomerReports extends ReportState {}
class EndFetchEmployeeCustomerReports extends ReportState {
  final ReportDataModel reportDataModel;

  EndFetchEmployeeCustomerReports({required this.reportDataModel});

  @override
  List<Object> get props => [reportDataModel];
}
class FetchEmployeeCustomerReportsError extends ReportState {

  final String msg;

  FetchEmployeeCustomerReportsError({required this.msg});

  @override
  List<Object> get props => [msg];
}


class StartUpdateFilters extends ReportState {}
class EndUpdateFilters extends ReportState {}

