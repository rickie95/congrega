
import 'package:congrega/user/UserRepository.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'authentication/AuthenticationRepository.dart';

void main() {
  runApp(Congrega(
    authenticationRepository: AuthenticationRepository(),
    userRepository: UserRepository(),
  ));
}