import 'package:equatable/equatable.dart';

class Event extends Equatable {
  const Event({
    required this.eventId,
    required this.name,
    required this.isDescRequired,
    required this.isDateRequired,

  });

  final int eventId;
  final String name;

  final bool isDescRequired;
  final bool isDateRequired;





  @override
  List<Object> get props => [eventId, name,isDescRequired, isDateRequired ];
}