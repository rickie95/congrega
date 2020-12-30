import 'package:flutter/material.dart';

class CongregaTheme {

  static final Color textColor = Colors.white;
  static final Color primaryColor = Colors.indigo;
  static final Color accentColor = Colors.indigoAccent;

  static final Brightness brightness = Brightness.dark;

  static ThemeData congregaTheme(){
    return ThemeData(

      brightness: brightness,
      primaryColor: primaryColor,
      accentColor: accentColor,

      fontFamily: 'Roboto',

      textTheme: TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}