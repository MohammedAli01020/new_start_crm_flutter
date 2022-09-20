part of 'event_cubit.dart';

@immutable
abstract class EventState extends Equatable {
  @override
  List<Object> get props => [];
}

class EventInitial extends EventState {}


class StartGetAllEventsByNameLike extends EventState {}

class EndGetAllEventsByNameLike extends EventState {

  final List<EventModel> fetchedEvents;
  EndGetAllEventsByNameLike({required this.fetchedEvents});

  @override
  List<Object> get props => [fetchedEvents];
}

class GetAllEventsByNameLikeError extends EventState {

  final String msg;
  GetAllEventsByNameLikeError({required this.msg});

  @override
  List<Object> get props => [msg];
}

class StartUpdateSelectedEvents extends EventState {}
class EndUpdateSelectedEvents extends EventState {}


class StartResetSelectedEvents extends EventState {}
class EndResetSelectedEvents extends EventState {}

class StartSetSelectedEvents extends EventState {}
class EndSetSelectedEvents extends EventState {}

class StartUpdateCurrentSelectedEvent extends EventState {}
class EndUpdateCurrentSelectedEvent extends EventState {}


class StartModifyEvent extends EventState {}
class EndModifyEvent extends EventState {
  final EventModel modifiedEvent;
  EndModifyEvent({required this.modifiedEvent});

  @override
  List<Object> get props => [modifiedEvent];
}
class ModifyEventError extends EventState {
  final String msg;
  ModifyEventError({required this.msg});

  @override
  List<Object> get props => [msg];
}


class StartDeleteEvent extends EventState {}
class EndDeleteEvent extends EventState {
  final int eventId;
  EndDeleteEvent({required this.eventId});

  @override
  List<Object> get props => [eventId];
}
class DeleteEventError extends EventState {
  final String msg;
  DeleteEventError({required this.msg});

  @override
  List<Object> get props => [msg];
}

