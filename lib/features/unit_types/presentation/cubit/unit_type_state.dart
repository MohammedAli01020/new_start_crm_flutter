part of 'unit_type_cubit.dart';

@immutable
abstract class UnitTypeState extends Equatable{

  @override
  List<Object?> get props => [];
}

class UnitTypeInitial extends UnitTypeState {}




class StartGetAllUnitTypesByNameLike extends UnitTypeState {}

class EndGetAllUnitTypesByNameLike extends UnitTypeState {

  final List<UnitTypeModel> fetchedUnitTypes;
  EndGetAllUnitTypesByNameLike({required this.fetchedUnitTypes});

  @override
  List<Object> get props => [fetchedUnitTypes];
}

class GetAllUnitTypesByNameLikeError extends UnitTypeState {

  final String msg;
  GetAllUnitTypesByNameLikeError({required this.msg});

  @override
  List<Object> get props => [msg];
}

class StartUpdateSelectedUnitTypes extends UnitTypeState {}
class EndUpdateSelectedUnitTypes extends UnitTypeState {}


class StartResetSelectedUnitTypes extends UnitTypeState {}
class EndResetSelectedUnitTypes extends UnitTypeState {}

class StartSetSelectedUnitTypes extends UnitTypeState {}
class EndSetSelectedUnitTypes extends UnitTypeState {}


class StartModifyUnitType extends UnitTypeState {}
class EndModifyUnitType extends UnitTypeState {
  final UnitTypeModel modifiedUnitType;
  EndModifyUnitType({required this.modifiedUnitType});

  @override
  List<Object> get props => [modifiedUnitType];
}
class ModifyUnitTypeError extends UnitTypeState {
  final String msg;
  ModifyUnitTypeError({required this.msg});

  @override
  List<Object> get props => [msg];
}


class StartDeleteUnitType extends UnitTypeState {}
class EndDeleteUnitType extends UnitTypeState {
  final int eventId;
  EndDeleteUnitType({required this.eventId});

  @override
  List<Object> get props => [eventId];
}
class DeleteUnitTypeError extends UnitTypeState {
  final String msg;
  DeleteUnitTypeError({required this.msg});

  @override
  List<Object> get props => [msg];
}
