import 'package:crm_flutter_project/features/customers/data/models/event_model.dart';

import 'package:crm_flutter_project/features/employees/data/models/employee_model.dart';

import '../../../employees/data/models/employee_response_model.dart';
import '../../domain/entities/last_action.dart';

class LastActionModel extends LastAction {
  const LastActionModel(
      {required int? dateTime,
      required int? postponeDateTime,
      required EventModel? event,
      required EmployeeResponseModel? lastActionBy,
      required String? actionDescription})
      : super(
            dateTime: dateTime,
            postponeDateTime: postponeDateTime,
            event: event,
            lastActionBy: lastActionBy,
            actionDescription: actionDescription);

  factory LastActionModel.fromJson(Map<String, dynamic> json) =>
      LastActionModel(
        dateTime: json["dateTime"],
        postponeDateTime: json["postponeDateTime"],
        event:
            json["event"] != null ? EventModel.fromJson(json["event"]) : null,
        lastActionBy: json["lastActionBy"] != null
            ? EmployeeResponseModel.fromJson(json["lastActionBy"])
            : null,
        actionDescription: json["actionDescription"],
      );

  Map<String, dynamic> toJson() => {
        "dateTime": dateTime,
        "postponeDateTime": postponeDateTime,
        "event": event?.toJson(),
        "lastActionBy": lastActionBy?.toJson(),
        "actionDescription": actionDescription,
      };
}
