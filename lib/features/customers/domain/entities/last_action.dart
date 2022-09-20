import 'package:equatable/equatable.dart';

import '../../../employees/data/models/employee_model.dart';
import '../../data/models/event_model.dart';

class LastAction extends Equatable {
  const LastAction({
    required this.dateTime,
    required this.postponeDateTime,

    required this.event,
    required this.lastActionBy,
    required this.actionDescription,
  });

  final int? dateTime;
  final int? postponeDateTime;
  final EventModel? event;
  final EmployeeModel? lastActionBy;
  final String? actionDescription;

  @override
  List<Object?> get props =>
      [dateTime, postponeDateTime, event, lastActionBy, actionDescription,];

}
