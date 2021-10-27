import 'dart:convert';

import 'package:congrega/features/users/UserHttpClient.dart';
import 'package:congrega/features/exceptions/HttpExceptions.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/utils/Arcano.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'AuthenticationHttpClient_test.mocks.dart';

final String twoUserList = '[{"id": 1,"username": "johnDoe","uri": "${Arcano.USERS_URL}/1"},'
    '{"id": 2, "username":"Jojo42", "uri": "${Arcano.USERS_URL}/2"}]';

final String emptyUserList = '[]';

@GenerateMocks([http.Client])
void main() {

  group('Get entire user list', (){

    test('should return a list of users.', () async {
      final client = MockClient();
      UserHttpClient userClient = new UserHttpClient(client);

      when(client.get(Uri(path: Arcano.USERS_URL))).thenAnswer(
              (_) async => http.Response(twoUserList, 200));

      List<User> userList = await userClient.getUserList();

      expect(userList, hasLength(2));
      expect(userList, contains(
          User(
              username: "johnDoe",
              id: '1',
          ),
      ));
    });

    test('should return an empty list of users.', () async {
      final client = MockClient();
      UserHttpClient userClient = new UserHttpClient(client);

      when(client.get(Uri(path: Arcano.USERS_URL))).thenAnswer(
              (_) async => http.Response(emptyUserList, 200));

      List<User> userList = await userClient.getUserList();

      expect(userList, hasLength(0));

    });

    test('should throws a NotFoundException if 404 is returned ', (){
      final client = MockClient();
      UserHttpClient userClient = new UserHttpClient(client);
      when(client.get(Uri(path: Arcano.USERS_URL))).thenAnswer(
              (_) async => http.Response('', 404));

      expect(userClient.getUserList(), throwsA(isInstanceOf<NotFoundException>()));
    });

    test('should throws a ServerErrorException if 500 is returned ', (){
      final client = MockClient();
      UserHttpClient userClient = new UserHttpClient(client);
      when(client.get(Uri(path: Arcano.USERS_URL))).thenAnswer(
              (_) async => http.Response('', 500));

      expect(userClient.getUserList(), throwsA(isInstanceOf<ServerErrorException>()));
    });

    test('should throws a OtherErrorException if other code is returned ', (){
      final client = MockClient();
      UserHttpClient userClient = new UserHttpClient(client);
      when(client.get(Uri(path: Arcano.USERS_URL))).thenAnswer(
              (_) async => http.Response('', 501));

      expect(userClient.getUserList(), throwsA(isInstanceOf<OtherErrorException>()));
    });

  });

  group('Get user by id',(){

    test('should return the correct user', () async {
      User user = User(name: "Mike Mayers", username: "mikey42",
          password: "secret", id: '1');

      final client = MockClient();
      UserHttpClient userClient = new UserHttpClient(client);

      final responseBody = jsonEncode(user.toJson());
      when(client.get(UserHttpClient.getUserEndpointById(user.id)))
          .thenAnswer((_) async => http.Response(responseBody, 200));

      User returnedUser = await  userClient.getUserById(user.id);

      expect(returnedUser, equals(user));

    });

    test('should throw NotFoundException if 404 is returned', () async {
      final User user = User.empty;
      final client = MockClient();
      UserHttpClient userClient = new UserHttpClient(client);

      when(client.get(UserHttpClient.getUserEndpointById(user.id)))
          .thenAnswer((_) async => http.Response('', 404));
      
      expect(userClient.getUserById(user.id),
          throwsA(isInstanceOf<NotFoundException>()));
    });

    test('should throw ServerErrorException if 500 is returned', () async {
      final User user = User.empty;
      final client = MockClient();
      UserHttpClient userClient = new UserHttpClient(client);

      when(client.get(UserHttpClient.getUserEndpointById(user.id)))
          .thenAnswer((_) async => http.Response('', 500));

      expect(userClient.getUserById(user.id),
          throwsA(isInstanceOf<ServerErrorException>()));
    });

    test('should throw OtherErrorException if different code is returned', () async {
      final User user = User.empty;
      final client = MockClient();
      UserHttpClient userClient = new UserHttpClient(client);

      when(client.get(UserHttpClient.getUserEndpointById(user.id)))
          .thenAnswer((_) async => http.Response('', 501));

      expect(userClient.getUserById(user.id),
          throwsA(isInstanceOf<OtherErrorException>()));
    });

  });
}