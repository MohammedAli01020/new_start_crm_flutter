part of 'customer_logs_cubit.dart';

@immutable
abstract class CustomerLogsState extends Equatable {
  @override
  List<Object> get props => [];
}

class CustomerLogsInitial extends CustomerLogsState {}


class StartUpdateFilter extends CustomerLogsState {}

class EndUpdateFilter extends CustomerLogsState {}

class StartResetFilter extends CustomerLogsState {}

class EndResetFilter extends CustomerLogsState {}

class StartRefreshCustomerLogs extends CustomerLogsState {}

class EndRefreshCustomerLogs extends CustomerLogsState {}

class RefreshCustomerLogsError extends CustomerLogsState {
  final String msg;

  RefreshCustomerLogsError({required this.msg});

  @override
  List<Object> get props => [msg];
}


class StartLoadingCustomerLogs extends CustomerLogsState {}

class EndLoadingCustomerLogs extends CustomerLogsState {}

class LoadingCustomerLogsError extends CustomerLogsState {
  final String msg;

  LoadingCustomerLogsError({required this.msg});

  @override
  List<Object> get props => [msg];
}

class LoadNoMoreCustomerLogs extends CustomerLogsState {}



class StartChangeCurrentPage extends CustomerLogsState{}
class EndChangeCurrentPage extends CustomerLogsState{}
