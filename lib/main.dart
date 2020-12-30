import 'package:flutter/material.dart';
import 'package:congrega/pages/WelcomePage.dart';
import 'package:congrega/theme/CongregaTheme.dart';
import 'package:congrega/controllers/CredentialsController.dart';
import 'package:congrega/pages/HomePage.dart';

void main() {
  // retrive info about user credentials

  CredentialsController.loadCredentials();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Congrega',
      theme: CongregaTheme.congregaTheme(),
      home: getInitialScreen(),
    );
  }
}

Widget getInitialScreen(){
  if(CredentialsController.isUserAuthenticated())
    return HomePage(title: "Home");

  return WelcomePage();
}



