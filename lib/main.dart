
import 'package:congrega/repositories/UserRepository.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'authentication/AuthenticationService.dart';

void main() {
  runApp(Congrega(
    authenticationRepository: AuthenticationService(),
    userRepository: UserRepository(),
  ));
}