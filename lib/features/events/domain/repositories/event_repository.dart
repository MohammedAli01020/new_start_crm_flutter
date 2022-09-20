import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../customers/data/models/event_model.dart';
import '../use_cases/events_use_cases.dart';
abstract class EventRepository {
  Future<Either<Failure, List<EventModel>>> getAllEventsByNameLike(
      {String? name});

  Future<Either<Failure, EventModel>> modifyEvent(
      ModifyEventParam modifyEventParam);

  Future<Either<Failure, void>> deleteEvent(int eventId);
}