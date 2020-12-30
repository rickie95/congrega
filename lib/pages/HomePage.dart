import 'package:flutter/material.dart';
import 'package:congrega/pages/CongregaDrawer.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  final String labelText ="Hello";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              labelText,
            ),
            FlatButton(
              child: Text('View Details'),
            ),
          ],
        ),
      ),
      drawer: CongregaDrawer.createDrawer(),
    );
  }
}