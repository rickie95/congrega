import 'dart:async';

import 'BaseTimeWidget.dart';

class StopwatchWidget extends BaseTimeWidget {
  @override
  BaseTimeWidgetState createState() => _StopwatchWidgetState();
}

class _StopwatchWidgetState extends BaseTimeWidgetState {

  Stopwatch _stopwatch;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    Timer.periodic(Duration(seconds: 1), (Timer t) => _updateState());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch?.stop();
    super.dispose();
  }

  void _updateState() {
    if(mounted &&_stopwatch != null &&_stopwatch.isRunning)
      setState(() { });
  }

  void reset(){ _stopwatch.reset(); }

  void pause() { _stopwatch.stop(); }

  void run() { _stopwatch.start(); }

  String get minutes => (_stopwatch.elapsed.inMinutes % 60).toString().padLeft(2, '0');
  String get seconds => (_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0');
  
}
