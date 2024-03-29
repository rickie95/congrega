import 'dart:async';

import 'package:congrega/features/lifecounter/presentation/widgets/timeWidgets/bloc/TimeSettingsBloc.dart';
import 'package:congrega/features/lifecounter/presentation/widgets/timeWidgets/bloc/TimeSettingsEvent.dart';
import 'package:congrega/features/lifecounter/presentation/widgets/timeWidgets/bloc/TimeSettingsState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'BaseTimeWidget.dart';

class TimerWidget extends BaseTimeWidget {
  
  @override
  BaseTimeWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends BaseTimeWidgetState {

  late Timer? _timer;
  late Duration _duration;
  late int secondsRemaining;


  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateState());
    _duration = BlocProvider
        .of<TimeSettingsBloc>(context)
        .state
        .duration;
    secondsRemaining = _duration.inSeconds;
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateState() {
    if (mounted)
      setState(() {
        secondsRemaining = secondsRemaining - 1;
        if (secondsRemaining == 0) {
          this.pause();
          this.reset();
          showAlertDialog();
        }
      });
  }

  void showAlertDialog() {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {},
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Time's up!"),
      actions: [
        okButton,
      ],
    ); // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void reset() {
    secondsRemaining = _duration.inSeconds;
  }

  void pause() {
    _timer?.cancel();
  }

  void run() {
    _timer = _timer ??
        Timer.periodic(Duration(seconds: 1), (Timer t) => _updateState());
  }

  String get minutes =>
      (secondsRemaining / 60).floor().toString().padLeft(2, '0');

  String get seconds => (secondsRemaining % 60).toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return BlocListener<TimeSettingsBloc, TimeSettingsState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        _duration = state.duration;
        if (state.status == TimeWidgetStatus.paused) {
          this.pause();
        } else if (state.status == TimeWidgetStatus.stopped) {
          this.reset();
          this.run();
          context.read<TimeSettingsBloc>().add(TimeWidgetResumed());
        } else if (state.status == TimeWidgetStatus.running) {
          this.run();
          context.read<TimeSettingsBloc>().add(TimeWidgetResumed());
        }
      },
      child: buildText(context),
    );
  }
}