import 'package:equatable/equatable.dart';

class Event extends Equatable {
  const Event({
    required this.eventId,
    required this.name,
  });

  final int eventId;
  final String name;



  @override
  List<Object> get props => [eventId, name];
}