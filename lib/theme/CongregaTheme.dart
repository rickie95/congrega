import 'package:flutter/material.dart';

class CongregaTheme {

  static final Color textColor = Colors.black;
  static final Color primaryColor = Colors.indigo;
  static final Color accentColor = Colors.indigoAccent;
  static final Brightness brightness = Brightness.light;
  static final Color backgroundColor = Colors.black;

  // Call to action button
  static final Color callToActionButtonBackground = Colors.white;
  static final Color callToActionButtonText = Colors.indigo;
  static final Color callToActionButtonShadow = Colors.indigo[900]!;

  static final callToActionButtonBackgroundDisabled = Colors.white54;

  static ThemeData congregaTheme(){
    return ThemeData(

      brightness: brightness,
      primaryColor: primaryColor,
      accentColor: accentColor,
      backgroundColor: backgroundColor,
      scaffoldBackgroundColor: backgroundColor,
       canvasColor: backgroundColor,


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
