import '../../domain/entities/create_action_request.dart';

class CreateActionRequestModel extends CreateActionRequest {
  const CreateActionRequestModel(
      {required int? dateTime,
      required int? postponeDateTime,
      required int? eventId,
      required int? lastActionByEmployeeId,
      required String? actionDescription})
      : super(
            dateTime: dateTime,
            postponeDateTime: postponeDateTime,
            eventId: eventId,
            lastActionByEmployeeId: lastActionByEmployeeId,
            actionDescription: actionDescription);

  factory CreateActionRequestModel.fromJson(Map<String, dynamic> json) =>
      CreateActionRequestModel(
        dateTime: json["dateTime"],
        postponeDateTime: json["postponeDateTime"],
        eventId: json["eventId"],
        lastActionByEmployeeId: json["lastActionByEmployeeId"],
        actionDescription: json["actionDescription"],
      );

  Map<String, dynamic> toJson() => {
        "dateTime": dateTime,
        "postponeDateTime": postponeDateTime,
        "eventId": eventId,
        "lastActionByEmployeeId": lastActionByEmployeeId,
        "actionDescription": actionDescription,
      };
}
