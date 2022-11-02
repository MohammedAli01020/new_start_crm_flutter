import '../../domain/entities/event.dart';

class EventModel extends Event {
  const EventModel({
    required int eventId,
    required String name,
    required bool isDescRequired,
    required bool isDateRequired,


  }) : super(eventId: eventId, name: name, isDateRequired: isDescRequired, isDescRequired: isDescRequired );
  factory EventModel.fromJson(Map<String, dynamic> json) =>
      EventModel(
        eventId: json["eventId"],
        name: json["name"],
        isDescRequired: json["isDescRequired"],
        isDateRequired: json["isDateRequired"]

      );

  Map<String, dynamic> toJson() =>
      {
        "eventId": eventId,
        "name": name,
        "isDescRequired": isDescRequired,
        "isDateRequired": isDateRequired,
      };
}