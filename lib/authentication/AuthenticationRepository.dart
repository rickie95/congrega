import 'dart:async';

import 'package:congrega/httpClients/AuthenticationHttpClient.dart';
import 'package:congrega/model/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {

  static const TOKEN  = "congrega_auth_token";

  AuthenticationRepository() : storage = new FlutterSecureStorage(), authClient = new AuthenticationHttpClient(new http.Client());

  final FlutterSecureStorage storage;
  final AuthenticationHttpClient authClient;
  final StreamController<AuthenticationStatus> _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  void logOut() {
    _deleteToken();
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  Future<void> logIn({@required User user }) async {

    await authClient.logIn(user)
        .then((String token) {
          persistToken(token);
          _controller.add(AuthenticationStatus.authenticated);
        });
  }

  Future<void> signIn({@required User user}) async {
      await authClient.signIn(user).then((value) => null);
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