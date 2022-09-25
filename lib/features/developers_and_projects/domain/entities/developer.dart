import 'package:equatable/equatable.dart';

class Developer extends Equatable {
  const Developer({
    required this.developerId,
    required this.name,
  });

  final int developerId;
  final String name;


  @override
  List<Object> get props => [developerId, name];
}
