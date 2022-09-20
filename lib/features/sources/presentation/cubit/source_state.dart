part of 'source_cubit.dart';

@immutable
abstract class SourceState extends Equatable {
  @override
  List<Object> get props => [];
}

class SourceInitial extends SourceState {}

class StartGetAllSourcesByNameLike extends SourceState {}

class EndGetAllSourcesByNameLike extends SourceState {

  final List<SourceModel> fetchedSources;
  EndGetAllSourcesByNameLike({required this.fetchedSources});

  @override
  List<Object> get props => [fetchedSources];
}

class GetAllSourcesByNameLikeError extends SourceState {

  final String msg;
  GetAllSourcesByNameLikeError({required this.msg});

  @override
  List<Object> get props => [msg];
}

class StartUpdateSelectedSources extends SourceState {}
class EndUpdateSelectedSources extends SourceState {}


class StartResetSelectedSources extends SourceState {}
class EndResetSelectedSources extends SourceState {}

class StartSetSelectedSources extends SourceState {}
class EndSetSelectedSources extends SourceState {}


class StartModifySource extends SourceState {}
class EndModifySource extends SourceState {
  final SourceModel modifiedSource;
  EndModifySource({required this.modifiedSource});

  @override
  List<Object> get props => [modifiedSource];
}
class ModifySourceError extends SourceState {
  final String msg;
  ModifySourceError({required this.msg});

  @override
  List<Object> get props => [msg];
}


class StartDeleteSource extends SourceState {}
class EndDeleteSource extends SourceState {
  final int eventId;
  EndDeleteSource({required this.eventId});

  @override
  List<Object> get props => [eventId];
}
class DeleteSourceError extends SourceState {
  final String msg;
  DeleteSourceError({required this.msg});

  @override
  List<Object> get props => [msg];
}
