import 'package:equatable/equatable.dart';

class UnitType extends Equatable {
  const UnitType({
    required this.unitTypeId,
    required this.name,
  });

  final int unitTypeId;
  final String name;



  @override
  List<Object> get props => [unitTypeId, name];
}