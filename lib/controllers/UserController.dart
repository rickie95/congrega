import 'dart:convert';

import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/utils/Arcano.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class UserController {

  static Future<void> getUserList() async {
    final response = await http.get(Uri(path:Arcano.USERS_URL));
    debugPrint(response.body);
  }
  
  static Future<void> saveNewUser(User user) async {

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Connection': 'keep-alive',
      'Accept': '*/*',
      'Accept-Encoding': 'gzip,deflate,br'
    };

    Map<String, String> body = {
      'name' : user.name,
      'username': user.username,
      'password': user.password,
      'role': 'PLAYER'
    };

    final response = await http.post(Uri(path:Arcano.USERS_URL),
        headers: headers, body: jsonEncode(body));

    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      debugPrint("User has been saved on server.");
      debugPrint(response.body);
      return;
    } else if (response.statusCode == 409)  {
      throw Exception('Username has been already taken');
    } else if(response.statusCode == 500){
      throw Exception('Server has encountered a problem.');
    }
    throw Exception("Cannot find the server");
  }

}