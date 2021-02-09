import 'package:flutter/material.dart';

import 'DashboardWideTile.dart';

class EventsWidget extends StatelessWidget {
  const EventsWidget({
    Key key,
  }) : super(key: key);

  Widget _body(BuildContext context){
    return Column (
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RaisedButton(onPressed: () {}, ),
        RaisedButton(onPressed: () {}, ),
        RaisedButton(onPressed: () {}, ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DashboardWideTile(
        title: 'Friends',
        child: Container(
          height: 120,
          child: _body(context),
        )
    );
  }
}