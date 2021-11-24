import 'package:flutter/material.dart';

class CongregaCircleLogo extends StatelessWidget {
  const CongregaCircleLogo() : super();

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.grey[100],
      backgroundImage: AssetImage('assets/congrega_logo.png'),
      radius: 50.0,
    );
  }
}