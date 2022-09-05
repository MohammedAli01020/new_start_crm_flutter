import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  final String? msg;

  const ServerException([this.msg]);

  @override
  List<Object?> get props => [msg];

  @override
  String toString() {
    return '$msg';
  }
}

class FetchDataException extends ServerException {
  const FetchDataException([message]) : super("Error During Communication");
}

class BadRequestException extends ServerException {
  const BadRequestException([message]) : super("Bad Request");
}

class UnauthorizedException extends ServerException {
  const UnauthorizedException([message]) : super("Unauthorized");
}

class NotFoundException extends ServerException {
  const NotFoundException([message]) : super("Requested Info Not Found");
}

class ConflictException extends ServerException {
  const ConflictException([message]) : super("Conflict Occurred");
}

class InternalServerErrorException extends ServerException {
  const InternalServerErrorException([message])
      : super("Internal Server Error");
}

class NoInternetConnectionException extends ServerException {
  const NoInternetConnectionException([message])
      : super("No Internet Connection");
}


class TemporaryRedirectException extends ServerException {
  const TemporaryRedirectException([message])
      : super("Temporary Redirect Exception");
}



class UnprocessableException extends ServerException {
  const UnprocessableException([message]) : super(" هذا الحساب مسجل من قبل اما رقم الهاتف او الايميل مووجود بالفعل");
}




class CacheException extends Equatable implements Exception {

  final String msg = "Cache Exception";

  @override
  List<Object?> get props => [msg];

}