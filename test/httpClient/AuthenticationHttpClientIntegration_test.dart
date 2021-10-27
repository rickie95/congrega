import 'dart:math';

import 'package:congrega/features/loginSignup/data/AuthenticationHttpClient.dart';
import 'package:congrega/features/loginSignup/model/UserCredentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

const String username = "test_";
const String password = "password";
const String name = "Jon Doe";

void main() {
  final random = Random();
  final UserCredentials user = new UserCredentials(
      username: username + random.nextInt(10000).toString(),
      password: password,
      name: name);

  group('SignIn', () {
    test('should register an user', () async {
      final client = http.Client();
      final AuthenticationHttpClient authClient =
          new AuthenticationHttpClient(client);

      expect(() => authClient.signIn(user), returnsNormally);
    });
  });

  group('Login', () {
    test('should authenticate the user', () async {
      final client = http.Client();
      final AuthenticationHttpClient authClient =
          new AuthenticationHttpClient(client);

      expect(() => authClient.logIn(user), returnsNormally);
    });
  });
}
