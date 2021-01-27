import 'dart:async';
import 'package:flutter/material.dart';

import 'BaseTimeWidget.dart';

class ClockWidget extends BaseTimeWidget {

  @override
  BaseTimeWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends BaseTimeWidgetState {

  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(minutes: 1), (Timer t) => _updateTime());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    if(mounted)
      setState(() {
        _dateTime = DateTime.now();
      });
  }

  String get minutes => _dateTime.hour.toString();
  String get seconds => (_dateTime.minute % 60).toString().padLeft(2, '0');

}