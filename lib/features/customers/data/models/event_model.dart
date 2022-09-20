import '../../domain/entities/event.dart';

class EventModel extends Event {
  const EventModel({required int eventId, required String name}) : super(eventId: eventId, name: name);
  factory EventModel.fromJson(Map<String, dynamic> json) =>
      EventModel(
        eventId: json["eventId"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() =>
      {
        "eventId": eventId,
        "name": name,
      };
}