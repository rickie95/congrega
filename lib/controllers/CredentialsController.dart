import 'package:http/http.dart' as http;
import 'dart:convert';

enum LoginStatus {
  NOT_AUTHENTICATED,
  AUTHENTICATED,
  WRONG_CREDENTIALS,
  SERVER_ERROR
}

class UserCredentials{

  String username;
  String password;
  String _token;

  LoginStatus loginStatus;

  UserCredentials({this.username, this.password}){
    this.loginStatus = LoginStatus.NOT_AUTHENTICATED;
  }

  void setToken(String token){
    this._token = token;
  }

  String getUsername(){
    return this.username;
  }

  String getPassword(){
    return this.password;
  }

  String getToken(){
    return this._token;
  }

  void setLoginStatus(LoginStatus status){
    this.loginStatus = status;
  }

  LoginStatus getLoginStatus(){
    return loginStatus;
  }
}

class CredentialsController {

  // Ask, store and send the JWT token

  static final String authenticationURL =
      'https://192.168.1.100/arcano/authentication';

  static UserCredentials user = new UserCredentials();

  static void loadCredentials(){
    // Lol, does nothing
  }


  static Future<void> authenticate(String username, String password, Function callback) async{
    user = new UserCredentials();
    //fetchToken(username, password);

    // AJAX to server through HTTPS
    // handle HTTP codes (200/403)
    // eventually throw exception
    // store jwt
    await Future.delayed( Duration(seconds: 2),
            () {
              user.setLoginStatus(LoginStatus.AUTHENTICATED);
              callback("CREDENTIALS CONTROLLER: OK");
            }
    );
  }

  static Future<String> fetchToken(String username, String password) async {

    final response = await http.post(authenticationURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );
/*
    if (response.statusCode == 200) {
      _token = response.body;
      loginStatus = LoginStatus.AUTHENTICATED;
    } else {
      loginStatus = LoginStatus.SERVER_ERROR;
      throw Exception('Failed to load album');
    }
    
 */
  }

  /*
  static Future<LoginStatus> getLoginStatus(){
    return Future.delayed(Duration(seconds: 2), () => loginStatus);
  }*/

  static bool isUserAuthenticated(){
    return false;
  }


  static Future<LoginStatus> getLoginStatus() async {
    return Future.delayed( Duration(seconds: 2),
          () => user.getLoginStatus(),
    );
  }


}