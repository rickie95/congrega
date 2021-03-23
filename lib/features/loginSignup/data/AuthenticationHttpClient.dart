import 'package:congrega/features/loginSignup/model/UserCredentials.dart';
import 'package:congrega/utils/Arcano.dart';
import 'package:http/http.dart' as http;

import '../../../httpClients/exceptions/HttpExceptions.dart';

class AuthenticationHttpClient {

  AuthenticationHttpClient(http.Client client) : httpClient = client;

  final http.Client httpClient;

  static Map<String, String> requestHeaders() => {
  "Content-Type": "application/json",
  "Accept": "*/*",
  "Connection": "keep-alive",
  "Accept-Encoding": "gzip, deflate, br"
  };

  static String createAuthBodyFrom(UserCredentials user){
    return '{"username" : "${user.username}", "password" : "${user.password}" }';
  }

  static String createSignInBodyFrom(UserCredentials user){
    return '{"username":"${user.username}", "password" : "${user.password}", "name" : "${user.name}"}';
  }
  
  Future<String> logIn(UserCredentials user) async {
    final response = await httpClient.post(
        Arcano.getAuthUri(),
        body: createAuthBodyFrom(user),
        headers: requestHeaders());

    switch(response.statusCode){
      case(200):
        return response.body;
      case(404):
        throw NotFoundException();
      case(403):
        throw UnauthorizedException();
      case(500):
        throw ServerErrorException();
    }

    throw OtherErrorException();
  }

  Future<void> signIn(UserCredentials user) async {
    final response = await httpClient.post(
        Arcano.getUsersUri(),
        body: createSignInBodyFrom(user),
        headers: requestHeaders());

    switch(response.statusCode){
      case(201):
        return null;
      case(404):
        throw NotFoundException();
      case(409):
        throw ConflictException();
      case(500):
        throw ServerErrorException();
    }

    throw OtherErrorException();

  }

}