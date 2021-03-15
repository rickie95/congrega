import 'package:equatable/equatable.dart';

class User extends Equatable {

  final BigInt id;

  final String name;
  final String username;
  final String password;

  const User({
    required this.id,
    this.name = "",
    required this.username,
    this.password = ""
  });

  @override
  List<Object> get props => [id, username];

  @override
  String toString(){
    return "[ID: $id | Name: $name | Username: $username | Password: $password]";
  }

  User copyWith({ BigInt? id, String? name, String? username, String? password}){
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: BigInt.from(json['id']),
      username: json['username'],
      password: json['password'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": this.id.toInt(),
    "name": this.name,
    "username": this.username,
    "password": this.password,
  };


}