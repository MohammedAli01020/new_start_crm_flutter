part of 'duplicates_cubit.dart';

@immutable
abstract class DuplicatesState extends Equatable {

  @override
  List<Object?> get props => [];
}

class DuplicatesInitial extends DuplicatesState {}



class StartFindDuplicateCustomers extends DuplicatesState {}

class EndFindDuplicateCustomers extends DuplicatesState {
  final List<CustomerModel> duplicatedByPhone;

  EndFindDuplicateCustomers({required this.duplicatedByPhone});

  @override
  List<Object> get props => [duplicatedByPhone];
}

class FindDuplicateCustomersError extends DuplicatesState {
  final String msg;

  FindDuplicateCustomersError({required this.msg});

  @override
  List<Object> get props => [msg];
}