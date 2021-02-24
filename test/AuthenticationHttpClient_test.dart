import 'package:congrega/authentication/AuthenticationHttpClient.dart';
import 'package:congrega/authentication/exceptions/HttpExceptions.dart';
import 'package:congrega/model/User.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

const String username = "jondoe";
const String password = "psswd";
const String name = "Jon Doe";

class MockClient extends Mock implements http.Client {}

void main(){
  User user = new User(username: username, password: password, name: name);


  
  group('SignIn', (){

    test('SignIn should send a POST request', () {
      final client = MockClient();
      AuthenticationHttpClient authClient = new AuthenticationHttpClient(client);

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      final body = '{"username":"${user.username}",password:"${user.password}", "name":${user.name}';
      when(client.post(AuthenticationHttpClient.USER_ENDPOINT_URL, body: body))
          .thenAnswer((_) async => http.Response('{"title": "Test"}', 200));

      authClient.signIn(user);
      verify(client.post(AuthenticationHttpClient.USER_ENDPOINT_URL, body: body));

    });

    test('SignIn should throw a NotFoundException is response code is 404', (){
      final client = MockClient();
      AuthenticationHttpClient authClient = new AuthenticationHttpClient(client);

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      final body = '{"username":"${user.username}",password:"${user.password}", "name":${user.name}';
      when(client.post(AuthenticationHttpClient.USER_ENDPOINT_URL, body: body))
          .thenAnswer((_) async => http.Response('', 404));

      expect(authClient.signIn(user), throwsA(isInstanceOf<NotFoundException>()));

    });

    test('SignIn should throw a ConflictException is response code is 409', (){
      final client = MockClient();
      AuthenticationHttpClient authClient = new AuthenticationHttpClient(client);

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      final body = '{"username":"${user.username}",password:"${user.password}", "name":${user.name}';
      when(client.post(AuthenticationHttpClient.USER_ENDPOINT_URL, body: body))
          .thenAnswer((_) async => http.Response('', 409));

      expect(authClient.signIn(user), throwsA(isInstanceOf<ConflictException>()));

    });

    test('SignIn should throw a ServerError is response code is 500', (){
      final client = MockClient();
      AuthenticationHttpClient authClient = new AuthenticationHttpClient(client);

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      final body = '{"username":"${user.username}",password:"${user.password}", "name":${user.name}';
      when(client.post(AuthenticationHttpClient.USER_ENDPOINT_URL, body: body))
          .thenAnswer((_) async => http.Response('', 500));

      expect(authClient.signIn(user), throwsA(isInstanceOf<ServerErrorException>()));

    });

    test('SignIn should throw a OtherError is response code different form 200/404/409/500', (){
      final client = MockClient();
      AuthenticationHttpClient authClient = new AuthenticationHttpClient(client);

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      final body = '{"username":"${user.username}",password:"${user.password}", "name":${user.name}';
      when(client.post(AuthenticationHttpClient.USER_ENDPOINT_URL, body: body))
          .thenAnswer((_) async => http.Response('', 300));

      expect(authClient.signIn(user), throwsA(isInstanceOf<OtherErrorException>()));

    });

  });
}