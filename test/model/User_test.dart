import 'package:flutter_test/flutter_test.dart';

import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:uuid/uuid.dart';

void main(){
  group('User::',(){

    final String id = Uuid().toString();
    final String name = "John Doe";
    final String username = "jd42";
    final String password = "secret@%23éà";

    test('toString should return a string representation of the object', (){
      User user = User(
        name: name,
        username: username,
        password: password,
        id: id
      );

      expect(user.toString(), equals("[ID: $id | Name: $name | Username: $username | Password: $password]"));

    });

    test("copyWith should return an equatable copy if no parameters are provided", (){
      User user = User(
          name: name,
          username: username,
          password: password,
          id: Uuid().toString()
      );

      expect(user.copyWith(), equals(user));
    });

    test("copyWith should return an equatable copy if non crucial parameters are provided", (){
      User user = User(
          name: name,
          username: username,
          password: password,
          id: Uuid().toString()
      );

      expect(user.copyWith(name: "James Doe", password: "lessSecret?"), equals(user));
    });

    test("copyWith should return a non equatable copy if crucial parameters are provided", (){
      User user = User(
          name: name,
          username: username,
          password: password,
          id: Uuid().toString()
      );

      expect(user.copyWith(username: "jamieDoe", password: "lessSecret?"), isNot(equals(user)));
    });

  });
}