import 'package:equatable/equatable.dart';

class User extends Equatable {

  final BigInt id;

  final String name;
  final String username;
  final String password;

  const User({this.id, this.name, this.username, this.password});

  @override
  List<Object> get props => [id, username];

  @override
  String toString(){
    return "[Name: $name | Username: $username | ID: $id]";
  }

  User copyWith({BigInt id, String name, String username, String password}){
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  static User fromJson(jsonBody) {
    return User(
      id: jsonBody['id'],
      username: jsonBody['username'],
      password: jsonBody['password'],
      name: jsonBody['name'],
    );
  }


}