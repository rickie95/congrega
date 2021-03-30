import 'dart:convert';

import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/utils/Arcano.dart';
import 'package:http/http.dart' as http;

import '../exceptions/HttpExceptions.dart';

class UserHttpClient {

  UserHttpClient(http.Client client) : httpClient = client;

  final http.Client httpClient;

  static Uri getUserEndpointById(String userId) => Uri(path: '${Arcano.USERS_URL}/$userId');

  Future<List<User>> getUserList() async {
    final response = await httpClient.get(Uri(path: Arcano.USERS_URL));

    switch(response.statusCode){
      case(200):
        // Create a collection from response's body
        final List<dynamic> jsonBody = jsonDecode(response.body) as List;
        return jsonBody.map((jsonObj) => User.fromJson(jsonObj)).toList();
      case(404):
        throw NotFoundException();
      case(500):
        throw ServerErrorException();
    }
    throw OtherErrorException();
  }

  Future<User> getUserById(String id) async {
    final response = await httpClient.get(getUserEndpointById(id));

    switch(response.statusCode){
      case(200):
      // Create an object from response's body
        final jsonBody = jsonDecode(response.body);
        return User.fromJson(jsonBody);
      case(404):
        throw NotFoundException();
      case(500):
        throw ServerErrorException();
    }
    throw OtherErrorException();
  }

}