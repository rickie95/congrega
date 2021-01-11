import 'package:equatable/equatable.dart';

class User extends Equatable {

  BigInt _id;

  String _name;
  String _username;
  String _password;

  User();

  @override
  List<Object> get props => [id, _username];

  @override
  String toString(){
    return "[Name: $_name | Username: $_username | ID: $_id]";
  }

  String get username { return this._username; }
  String get password { return this._password; }
  String get name { return this._name; }
  BigInt get id { return this._id; }

  set username (String username){ _username = username; }
  set password (String password){ _password = password; }
  set name (String name) { _name = name; }
  set id (BigInt id) { _id = id; }

  static User fromJson(jsonBody) {
    User user = User();
    user.id = jsonBody['id'];
    user.username = jsonBody['username'];
    user.password = jsonBody['password'];
    user.name = jsonBody['name'];

    return user;
  }


}