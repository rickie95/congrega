import 'dart:convert';

import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/utils/Arcano.dart';
import 'package:http/http.dart' as http;

import '../exceptions/HttpExceptions.dart';

class UserHttpClient {
  static Uri getUserEndpointById(String userId) => Uri(path: '${Arcano.USERS_URL}/$userId');
  static Uri getUserEndpointByUsername(String username) =>
      Uri(path: '${Arcano.USERS_URL_BY_USERNAME}/$username');

  UserHttpClient(http.Client client) : httpClient = client;
  final http.Client httpClient;

  Future<List<User>> getUserList() async {
    final response = await httpClient.get(Arcano.getUsersUri());

    switch (response.statusCode) {
      case (200):
        // Create a collection from response's body
        final List<dynamic> jsonBody = jsonDecode(response.body) as List;
        return jsonBody.map((jsonObj) => User.fromJson(jsonObj)).toList();
      case (404):
        throw NotFoundException();
      case (500):
        throw ServerErrorException();
    }
    throw OtherErrorException();
  }

  Future<User> getUserById(String id) async {
    final response = await httpClient.get(getUserEndpointById(id));

    switch (response.statusCode) {
      case (200):
        // Create an object from response's body
        final jsonBody = jsonDecode(response.body);
        return User.fromJson(jsonBody);
      case (404):
        throw NotFoundException();
      case (500):
        throw ServerErrorException();
    }
    throw OtherErrorException();
  }

  Future<User> getUserByUsername(String username) async {
    Uri uri = Arcano.getUserByUsernameUri(username);
    final response = await httpClient.get(uri);

    switch (response.statusCode) {
      case (200):
        // Create an object from response's body
        final jsonBody = jsonDecode(response.body);
        return User.fromJson(jsonBody);
      case (404):
        throw NotFoundException();
      case (500):
        throw ServerErrorException();
    }
    throw OtherErrorException();
  }

  Future<List<User>> searchByUsername(String username) {
    return getUserList().then((results) => results
        .where((user) => user.name.contains(username) || user.username.contains(username))
        .toList());
  }
}
