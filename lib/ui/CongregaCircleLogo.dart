import 'package:flutter/material.dart';
import 'dart:io';

class CongregaCircleLogo extends StatelessWidget {
  const CongregaCircleLogo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.grey[100],
      backgroundImage: AssetImage('assets/congrega_logo.png'),
      radius: 50.0,
    );
  }
}