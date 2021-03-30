import 'package:equatable/equatable.dart';

class User extends Equatable {

  final String id;
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

  User copyWith({ String? id, String? name, String? username, String? password}){
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      username: json['username'],
      password: json['password'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": this.id,
    "name": this.name,
    "username": this.username,
    "password": this.password,
  };


  static const empty = User(id: '-', username: '-');


}