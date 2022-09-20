import 'package:equatable/equatable.dart';

class Permission extends Equatable {
  const Permission({
    required this.permissionId,
    required this.name,
  });

  final int permissionId;
  final String name;



  @override
  List<Object> get props => [permissionId, name];
}