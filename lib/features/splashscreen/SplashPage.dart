import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SplashPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
          child: Column(children: [
        const Padding(padding: EdgeInsets.all(50)),
        const Text(
          "Congrega",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50, color: Colors.white),
        ),
        const Padding(padding: EdgeInsets.all(70)),
        CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white), strokeWidth: 5),
        const Padding(padding: EdgeInsets.all(80)),
        const Text(
          "Gathering all the wizards...",
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ])),
    );
  }
}
