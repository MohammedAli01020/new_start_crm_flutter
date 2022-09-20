import 'package:equatable/equatable.dart';

class Source extends Equatable {
  const Source({
    required this.sourceId,
    required this.name,
  });

  final int sourceId;
  final String name;



  @override
  List<Object> get props => [sourceId, name];
}