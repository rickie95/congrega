import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {

  static const TOKEN  = "congrega_auth_token";
  static const String USER_ENDPOINT_URL = "https://192.168.1.53:8443/arcano/users";
  static const String AUTH_ENDPOINT_URL = "https://192.168.1.53:8443/arcano/authenticate";

  final FlutterSecureStorage storage;
  final _controller = StreamController<AuthenticationStatus>();
  
  AuthenticationRepository() : storage = new FlutterSecureStorage();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  void logOut() {
    _deleteToken();
    _controller.add(AuthenticationStatus.unauthenticated);
  }
  
  Future<void> logIn({
    @required String username,
    @required String password,
  }) async {
    final body = '{"username":"$username",password:"$password"}';
    final response = await http.post(AUTH_ENDPOINT_URL, body: body);

    switch(response.statusCode){
      case(200):
        persistToken(response.body);
        _controller.add(AuthenticationStatus.authenticated);
        break;
      case(404):
        debugPrint("ERROR 404 while authenticating towards $USER_ENDPOINT_URL");
        break;
      case(403):
        break;
    }
    return 'token';
  }

  Future<void> signIn({
    @required String username,
    @required String password,
    String name,
  }) async {
    final body = '{"username":"$username","password":"$password","name":"$name"}';
    final response = await http.post(AUTH_ENDPOINT_URL, body: body);

    switch(response.statusCode){
      case(201): // CREATED
        persistToken(response.body);
        break;
      case(404): // NOT FOUND
        break;
      case(406): // CONFLICT
        break;
    }

  }

  Future<void> _deleteToken() async {
    /// delete from keystore/keychain
    await storage.delete(key: TOKEN);
    return;
  }

  Future<void> persistToken(String token) async {
    /// write to keystore/keychain
    await storage.write(key: TOKEN, value: token);
    return;
  }

  Future<bool> hasToken() async {
    /// read from keystore/keychain
    String value = await storage.read(key: TOKEN);
    return !(value == null);
  }

  void dispose() => _controller.close();
}