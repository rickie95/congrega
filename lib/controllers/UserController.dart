import 'dart:convert';

import 'package:congrega/model/User.dart';
import 'package:congrega/utils/Arcano.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class UserController {

  static const String USER_ENDPOINT_URL = Arcano.USERS_URL;
  
  static Future<void> saveNewUser(User user) async {

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    Map<String, String> body = {
      'name' : user.name,
      'username': user.username,
      'password': user.password,

    };

    final response = await http.post(USER_ENDPOINT_URL,
        headers: headers, body: body);

    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      debugPrint("User has been saved on server.");
    } else if (response.statusCode == 409)  {
      // Username already taken
      throw Exception('Username has been already taken');
    }
  }

  
}