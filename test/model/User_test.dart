import 'package:flutter_test/flutter_test.dart';

import 'package:congrega/features/loginSignup/model/User.dart';

void main(){
  group('User::',(){

    final BigInt id = BigInt.one;
    final String name = "John Doe";
    final String username = "jd42";
    final String password = "secret@%23éà";

    test('toString should return a string representation of the object', (){
      User user = User(
        name: name,
        username: username,
        password: password,
        id: BigInt.one
      );

      expect(user.toString(), equals("[ID: $id | Name: $name | Username: $username | Password: $password]"));

    });

    test("copyWith should return an equatable copy if no parameters are provided", (){
      User user = User(
          name: name,
          username: username,
          password: password,
          id: BigInt.one
      );

      expect(user.copyWith(), equals(user));
    });

    test("copyWith should return an equatable copy if non crucial parameters are provided", (){
      User user = User(
          name: name,
          username: username,
          password: password,
          id: BigInt.one
      );

      expect(user.copyWith(name: "James Doe", password: "lessSecret?"), equals(user));
    });

    test("copyWith should return a non equatable copy if crucial parameters are provided", (){
      User user = User(
          name: name,
          username: username,
          password: password,
          id: BigInt.one
      );

      expect(user.copyWith(username: "jamieDoe", password: "lessSecret?"), isNot(equals(user)));
    });

  });
}