import 'package:congrega/model/User.dart';
import 'package:http/http.dart' as http;
import 'package:congrega/authentication/exceptions/HttpExceptions.dart';

class AuthenticationHttpClient {

  AuthenticationHttpClient(http.Client client) : httpClient = client;

  final http.Client httpClient;
  static const String USER_ENDPOINT_URL = "https://192.168.1.53:8443/arcano/users";
  static const String AUTH_ENDPOINT_URL = "https://192.168.1.53:8443/arcano/authenticate";

  Future<String> logIn(User user) async {
    final body = '{"username":"${user.username}",password:"${user.password}"}';
    final response = await httpClient.post(AUTH_ENDPOINT_URL, body: body);

    switch(response.statusCode){
      case(200):
        return response.body;
        break;
      case(404):
        throw NotFoundException();
        break;
      case(403):
        throw UnauthorizedException();
        break;
      case(500):
        throw ServerErrorException();
        break;
    }

    throw OtherErrorException();
  }

  Future<void> signIn(User user) async {
    final body = '{"username":"${user.username}",password:"${user.password}", "name":${user.name}';
    final response = await httpClient.post(USER_ENDPOINT_URL, body: body);

    switch(response.statusCode){
      case(200):
        return null;
        break;
      case(404):
        throw NotFoundException();
        break;
      case(409):
        throw ConflictException();
        break;
      case(500):
        throw ServerErrorException();
        break;
    }

    throw OtherErrorException();

  }

}