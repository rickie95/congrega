import 'dart:convert';
import 'dart:io';

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

    test('toJson and FromJson', (){
      User user = User(id: '1', name: 'Mike', username: 'mike', password: 'secret');

      String jsonVersion = jsonEncode(user);

      User decodedUser = User.fromJson(jsonDecode(jsonVersion));

      expect(decodedUser, equals(user));

    });

    test(' toJson as a list', (){
      User user = User(id: '1', name: 'Mike', username: 'mike', password: 'secret');
      User otherUser = User(id: '2', name: 'Bob', username: 'bob', password: 'secret');

      String userListBody = jsonEncode(List<User>.of([user, otherUser]));

      Iterable i = jsonDecode(userListBody);
      List<User> userList = List<User>.from(i.map((model) => User.fromJson(model)));

      expect(userList, hasLength(2));
      expect(userList, containsAll([user, otherUser]));

    });

  });
}