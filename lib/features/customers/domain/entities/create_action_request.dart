import 'package:equatable/equatable.dart';

class CreateActionRequest extends Equatable {

  final int? dateTime;
  final int? postponeDateTime;
  final int? eventId;
  final int? lastActionByEmployeeId;
  final String? actionDescription;

  const CreateActionRequest({
    required this.dateTime,
    required this.postponeDateTime,
    required this.eventId,
    required this.lastActionByEmployeeId,
    required this.actionDescription});

  @override
  List<Object?> get props =>
      [dateTime, eventId, lastActionByEmployeeId, actionDescription,];
}