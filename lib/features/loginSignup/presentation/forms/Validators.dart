import 'dart:core';

class Validators {

  static Function alwaysTrueValidator = (String value){ return null; };

  static Function passwordValidator = (String password){
    if(password.isEmpty || password.length < 8)
      return "Password must be at least 8 characters";

    return null;
  };

  static Function usernameValidator = (String username){
    if(username.isEmpty || username.length < 6)
      return "Username must be at least 6 characters";

    return null;
  };

}