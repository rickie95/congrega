class User {

  String _name;
  String _username;
  String _password;

  BigInt _id;

  User(String username, String password, [String name, BigInt id]){
    this._username = username;
    this._password = password;

    if(name != null && name.isNotEmpty)
      this._name = name;

    if(id != null && id.isValidInt)
      this._id = id;

  }

  @override
  String toString(){
    return "[Name: $_name | Username: $_username | ID: $_id]";
  }

  String get username { return this._username; }
  String get password { return this._password; }
  String get name { return this._name; }
  BigInt get id { return this._id; }

  static Future<User> fromJson(jsonDecode) {
    return User("prova", "prova2");
  }

}