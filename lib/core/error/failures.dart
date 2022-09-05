import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String? msg;

  const Failure({required this.msg});

  @override
  List<Object?> get props => [msg];
}


class ServerFailure extends Failure {
  const ServerFailure({required String? msg}) : super(msg: msg);


}

class CacheFailure extends Failure {
  const CacheFailure({required String? msg}) : super(msg: msg);

}


