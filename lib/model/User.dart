class User {

  String _name;
  String _username;
  String _password;

  BigInt _id;

  User(String username, String password, [String name, BigInt id]){
    this._username = username;
    this._password = password;

    if(name.isNotEmpty)
      this._name = name;

    if(id.isValidInt)
      this._id = id;

  }

  String get username { return this._username; }
  String get password { return this._password; }
  String get name { return this._name; }
  BigInt get id { return this._id; }

}