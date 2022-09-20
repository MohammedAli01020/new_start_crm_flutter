import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../../customers/data/models/event_model.dart';
import '../../domain/use_cases/events_use_cases.dart';

abstract class EventRemoteDataSource {
  Future<List<EventModel>> getAllEventsByNameLike(
      {String? name});

  Future<EventModel> modifyEvent(
      ModifyEventParam modifyEventParam);

  Future< void> deleteEvent(int eventId);
}

class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  final ApiConsumer apiConsumer;

  EventRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<void> deleteEvent(int eventId) async {
    return await apiConsumer.delete(EndPoints.deleteEvent + eventId.toString());
  }

  @override
  Future<List<EventModel>> getAllEventsByNameLike({String? name}) async {
    final response = await apiConsumer
        .get(EndPoints.allEvent, queryParameters: {"name": name});

    return List<EventModel>.from(response.map((x) => EventModel.fromJson(x)));
  }

  @override
  Future<EventModel> modifyEvent(ModifyEventParam modifyEventParam) async {
    final response = await apiConsumer.post(EndPoints.modifyEvent,
        body: modifyEventParam.toJson());

    return EventModel.fromJson(response);
  }

}
