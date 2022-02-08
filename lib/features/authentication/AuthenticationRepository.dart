import 'dart:async';
import 'dart:io';

import 'package:congrega/features/exceptions/HttpExceptions.dart';
import 'package:congrega/features/loginSignup/data/AuthenticationHttpClient.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/features/loginSignup/model/UserCredentials.dart';
import 'package:congrega/features/users/UserRepository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  static const TOKEN = "congrega_auth_token";
  static const OFFLINE_TOKEN = "OFFLINE";

  AuthenticationRepository({
    required this.storage,
    required this.authClient,
    required this.userRepository,
  });

  final UserRepository userRepository;
  final FlutterSecureStorage storage;
  final AuthenticationHttpClient authClient;
  final StreamController<AuthenticationStatus> _controller =
      StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    yield await credentialsSaved().then((isAuthenticated) => isAuthenticated
        ? AuthenticationStatus.authenticated
        : AuthenticationStatus.unauthenticated);
    yield* _controller.stream;
  }

  void logOut() {
    _deleteToken();
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void logInCurrentUser() async {
    User currentUser = await userRepository.getUser();
    UserCredentials credentials = UserCredentials(
        username: currentUser.username, password: currentUser.password, name: currentUser.name);
    authClient
        .logIn(credentials)
        .then((token) => saveUserInfo(credentials, token))
        .then((_) => _controller.add(AuthenticationStatus.authenticated))
        .onError((error, stackTrace) {
      if (error is ConnectionException) {
        saveUserInfo(credentials, OFFLINE_TOKEN);
      } else if (error is NotFoundException) {
        signIn(user: credentials);
      } else if (error is UnauthorizedException) {
        signIn(user: credentials);
      } else if (error is ForbiddenException) {
        _controller.add(AuthenticationStatus.unauthenticated);
      }
    });
  }

  Future<void> saveUserInfo(UserCredentials user, String token) =>
      persistToken(token).then((_) => userRepository.saveUserInfo(user));

  Future<void> logIn({required UserCredentials user}) async {
    authClient
        .logIn(user)
        .then((String token) => saveUserInfo(user, token))
        .then((_) => _controller.add(AuthenticationStatus.authenticated));
  }

  Future<void> signIn({required UserCredentials user}) async {
    authClient
        .signIn(user)
        .then((_) => saveUserInfo(user, OFFLINE_TOKEN))
        .then((_) => logIn(user: user))
        .then((_) => _controller.add(AuthenticationStatus.authenticated));
  }

  Future<void> _deleteToken() async {
    /// delete from keystore/keychain
    storage.delete(key: TOKEN);
  }

  Future<void> persistToken(String token) async {
    /// write to keystore/keychain
    storage.write(key: TOKEN, value: token);
  }

  Future<String?> getToken() async {
    User u = await userRepository.getUser();
    UserCredentials cred = UserCredentials(username: u.username, password: u.password);
    return await authClient.logIn(cred);
  }

  Future<bool> credentialsSaved() async {
    /// read from keystore/keychain
    return ((await storage.read(key: TOKEN)) != null);
  }

  void dispose() => _controller.close();
}
