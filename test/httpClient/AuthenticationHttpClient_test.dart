import 'package:congrega/features/loginSignup/data/AuthenticationHttpClient.dart';
import 'package:congrega/features/loginSignup/model/UserCredentials.dart';
import 'package:congrega/features/exceptions/HttpExceptions.dart';
import 'package:congrega/utils/Arcano.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

const String username = "jondoe";
const String password = "psswd";
const String name = "Jon Doe";

class MockClient extends Mock implements http.Client {}

void main(){
  final UserCredentials user = new UserCredentials(username: username, password: password, name: name);

  group('SignIn', (){

    test('SignIn should send a POST request', () {
      final client = MockClient();
      AuthenticationHttpClient authClient = new AuthenticationHttpClient(client);

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      final String body = AuthenticationHttpClient.createSignInBodyFrom(user);
      when(client.post(Arcano.getUsersUri(), body: body, headers: AuthenticationHttpClient.requestHeaders()))
          .thenAnswer((_) async => http.Response('{"title": "Test"}', 201));

      authClient.signIn(user);
      verify(client.post(Arcano.getUsersUri(), body: body, headers: AuthenticationHttpClient.requestHeaders()));

    });

    test('SignIn should throw a NotFoundException is response code is 404', (){
      final client = MockClient();
      AuthenticationHttpClient authClient = new AuthenticationHttpClient(client);

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      final String body = AuthenticationHttpClient.createSignInBodyFrom(user);
      when(client.post(Arcano.getUsersUri(), body: body, headers: AuthenticationHttpClient.requestHeaders()))
          .thenAnswer((_) async => http.Response('', 404));

      expect(authClient.signIn(user), throwsA(isInstanceOf<NotFoundException>()));

    });

    test('SignIn should throw a ConflictException is response code is 409', (){
      final client = MockClient();
      AuthenticationHttpClient authClient = new AuthenticationHttpClient(client);

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      final String body = AuthenticationHttpClient.createSignInBodyFrom(user);
      when(client.post(Arcano.getUsersUri(), body: body, headers: AuthenticationHttpClient.requestHeaders()))
          .thenAnswer((_) async => http.Response('', 409));

      expect(authClient.signIn(user), throwsA(isInstanceOf<ConflictException>()));

    });

    test('SignIn should throw a ServerError is response code is 500', (){
      final client = MockClient();
      AuthenticationHttpClient authClient = new AuthenticationHttpClient(client);

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      final String body = AuthenticationHttpClient.createSignInBodyFrom(user);
      when(client.post(Arcano.getUsersUri(), body: body, headers: AuthenticationHttpClient.requestHeaders()))
          .thenAnswer((_) async => http.Response('', 500));

      expect(authClient.signIn(user), throwsA(isInstanceOf<ServerErrorException>()));

    });

    test('SignIn should throw a OtherError is response code different form 200/404/409/500', (){
      final client = MockClient();
      AuthenticationHttpClient authClient = new AuthenticationHttpClient(client);

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      final String body = AuthenticationHttpClient.createSignInBodyFrom(user);
      when(client.post(Arcano.getUsersUri(), body: body, headers: AuthenticationHttpClient.requestHeaders()))
          .thenAnswer((_) async => http.Response('', 300));

      expect(authClient.signIn(user), throwsA(isInstanceOf<OtherErrorException>()));

    });

  });

  group('logIn', () {

    test('LogIn should send a POST request, returning OK, with token embroided in body', () {
      final token = 'this_but_a_scratch';
      final client = MockClient();
      AuthenticationHttpClient authClient = new AuthenticationHttpClient(client);

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      final body = AuthenticationHttpClient.createAuthBodyFrom(user);
      when(client.post(
          Arcano.getAuthUri(),
          body: body,
          headers: AuthenticationHttpClient.requestHeaders()))
          .thenAnswer((_) async => http.Response(token, 200));

      authClient.logIn(user);
      verify(client.post(Arcano.getAuthUri(), body: body, headers: AuthenticationHttpClient.requestHeaders()));
    });

    test('LogIn should throws a NotFoundException if 404 is returned', () {
      final client = MockClient();
      AuthenticationHttpClient authClient = new AuthenticationHttpClient(client);

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      final body =  AuthenticationHttpClient.createAuthBodyFrom(user);
      when(client.post(Arcano.getAuthUri(), body: body, headers: AuthenticationHttpClient.requestHeaders()))
          .thenAnswer((_) async => http.Response('', 404));

      expect(authClient.logIn(user), throwsA(isInstanceOf<NotFoundException>()));

    });

    test('LogIn should throws a UnauthorizedException if 403 is returned', () {
      final client = MockClient();
      AuthenticationHttpClient authClient = new AuthenticationHttpClient(client);

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      final body =  AuthenticationHttpClient.createAuthBodyFrom(user);
      when(client.post(Arcano.getAuthUri(), body: body, headers: AuthenticationHttpClient.requestHeaders()))
          .thenAnswer((_) async => http.Response('', 403));

      expect(authClient.logIn(user), throwsA(isInstanceOf<UnauthorizedException>()));
    });

    test('LogIn should throws a ServerErrorException if 500 is returned', ()  {
      final client = MockClient();
      AuthenticationHttpClient authClient = new AuthenticationHttpClient(client);

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      final body =  AuthenticationHttpClient.createAuthBodyFrom(user);
      when(client.post(Arcano.getAuthUri(), body: body, headers: AuthenticationHttpClient.requestHeaders()))
          .thenAnswer((_) async => http.Response('', 500));

      expect(authClient.logIn(user), throwsA(isInstanceOf<ServerErrorException>()));
    });

    test('LogIn should throws a OtherErrorException if other code is returned', () {
      final client = MockClient();
      AuthenticationHttpClient authClient = new AuthenticationHttpClient(client);

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      final body =  AuthenticationHttpClient.createAuthBodyFrom(user);
      when(client.post(Arcano.getAuthUri(), body: body, headers: AuthenticationHttpClient.requestHeaders()))
          .thenAnswer((_) async => http.Response('', 300));

      expect(authClient.logIn(user), throwsA(isInstanceOf<OtherErrorException>()));
    });

  }
  );
}