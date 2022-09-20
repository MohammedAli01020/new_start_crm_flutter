import 'package:crm_flutter_project/features/customers/data/models/event_model.dart';
import 'package:crm_flutter_project/features/events/domain/repositories/event_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class EventsUseCases {
  Future<Either<Failure, List<EventModel>>> getAllEventsByNameLike(
      {String? name});

  Future<Either<Failure, EventModel>> modifyEvent(
      ModifyEventParam modifyEventParam);

  Future<Either<Failure, void>> deleteEvent(int eventId);
}

class EventsUseCasesImpl implements EventsUseCases {
  final EventRepository eventRepository;

  EventsUseCasesImpl({required this.eventRepository});


  @override
  Future<Either<Failure, void>> deleteEvent(int eventId) {

    return eventRepository.deleteEvent(eventId);
  }

  @override
  Future<Either<Failure, List<EventModel>>> getAllEventsByNameLike(
      {String? name}) {
    return eventRepository.getAllEventsByNameLike(name: name);
  }

  @override
  Future<Either<Failure, EventModel>> modifyEvent(
      ModifyEventParam modifyEventParam) {
    return eventRepository.modifyEvent(modifyEventParam);
  }

}


class ModifyEventParam extends Equatable {
  final int? eventId;

  final String name;


  const ModifyEventParam({
    required this.eventId,
    required this.name,
  });

  Map<String, dynamic> toJson() =>
      {"eventId": eventId, "name": name};

  @override
  List<Object?> get props => [eventId, name];
}