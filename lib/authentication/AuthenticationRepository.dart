import 'dart:async';

import 'package:congrega/features/loginSignup/data/AuthenticationHttpClient.dart';
import 'package:congrega/features/loginSignup/model/UserCredentials.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {

  static const TOKEN  = "congrega_auth_token";

  AuthenticationRepository({
    required this.storage,
    required this.authClient
  });

  final FlutterSecureStorage storage;
  final AuthenticationHttpClient authClient;
  final StreamController<AuthenticationStatus> _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  void logOut() {
    _deleteToken();
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  Future<void> logIn({required UserCredentials user }) async {

    await authClient.logIn(user)
        .then((String token) {
      persistToken(token);
      _controller.add(AuthenticationStatus.authenticated);
    });
  }

  Future<void> signIn({required UserCredentials user}) async {
    await authClient.signIn(user).then((_) {
      // If sign in ends well, perform login and get token
      logIn(user: user);
    });
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
    return !((await storage.read(key: TOKEN)) == null);
  }

  void dispose() => _controller.close();
}