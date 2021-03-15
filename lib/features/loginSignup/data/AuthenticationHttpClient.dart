import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/features/loginSignup/model/UserCredentials.dart';
import 'package:http/http.dart' as http;

import '../../../httpClients/exceptions/HttpExceptions.dart';

class AuthenticationHttpClient {

  AuthenticationHttpClient(http.Client client) : httpClient = client;

  final http.Client httpClient;
  static const String BASE_URL = "https://192.168.1.59:8443";
  static const String USER_ENDPOINT_URL = BASE_URL + "/arcano/users";
  static const String AUTH_ENDPOINT_URL =  BASE_URL + "/arcano/authenticate";

  static String createAuthBodyFrom(UserCredentials user){
    return '{"username" : "${user.username}", "password" : "${user.password}" }';
  }

  static String createSignInBodyFrom(UserCredentials user){
    return '{"username":"${user.username}", "password" : "${user.password}", "name" : "${user.name}"}';
  }

  Future<String> logIn(UserCredentials user) async {
    final body = createAuthBodyFrom(user);
    final response = await httpClient.post(Uri(path: AUTH_ENDPOINT_URL), body: body);

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
    final body = createSignInBodyFrom(user);
    final response = await httpClient.post(Uri(path: USER_ENDPOINT_URL), body: body);

    switch(response.statusCode){
      case(200):
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