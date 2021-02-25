class UnauthorizedException implements Exception {

  const UnauthorizedException({this.message}) : super();

  final String message;

}

class NotFoundException implements Exception {

  const NotFoundException({this.message}) : super();

  final String message;

}

class ServerErrorException implements Exception {

  const ServerErrorException({this.message}) : super();

  final String message;

}

class ConflictException implements Exception {

  const ConflictException({this.message}) : super();

  final String message;

}

class OtherErrorException implements Exception {

  const OtherErrorException({this.message}) : super();

  final String message;

}

