
import 'package:congrega/features/lifecounter/presentation/widgets/timeWidgets/bloc/TimeSettingsBloc.dart';
import 'package:congrega/features/lifecounter/presentation/widgets/timeWidgets/bloc/TimeSettingsEvent.dart';
import 'package:congrega/features/lifecounter/presentation/widgets/timeWidgets/bloc/TimeSettingsState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../TimeWidgetSettingsModalBottomSheet.dart';
import 'ClockWidget.dart';
import 'StopwatchWidget.dart';
import 'TimerWidget.dart';

enum TimeWidgetType { ClockWidget, Stopwatch, TimerWidget }

class TimeWidget extends StatelessWidget {

  static final String clockWidgetName = "Clock";
  static final String timerWidgetName = "Timer";
  static final String stopWatchWidgetName = "Stopwatch";

  static final String clockWidgetDescription = "A simple widget showing the current time";
  static final String stopwatchWidgetDescription = "Keeps track of the time passed";
  static final String timerWidgetDescription = "Countdown from a desired time";


  const TimeWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
          child: GestureDetector(
            
            onDoubleTap: () { BlocProvider.of<TimeSettingsBloc>(context).add(TimeWidgetPausedOrResumed());},
            onTap: () => showModalBottomSheet<void>( context: context,  builder: (_) {
              return BlocProvider.value(
                  value: BlocProvider.of<TimeSettingsBloc>(context),
                  child: TimeWidgetSettingsModalBottomSheet());
            }),
            child: BlocBuilder<TimeSettingsBloc, TimeSettingsState>(
                buildWhen: (previous, current) => previous.timeWidgetType != current.timeWidgetType,
                builder: (context, state) {
                  if(state.timeWidgetType == TimeWidgetType.TimerWidget)
                    return TimerWidget();

                  if(state.timeWidgetType == TimeWidgetType.Stopwatch)
                    return StopwatchWidget();

                  return ClockWidget();
                }),
          ),
        ));
  }

  static getTimeWidgetDescription(TimeWidgetType type){
    if(type == TimeWidgetType.ClockWidget)
      return clockWidgetDescription;

    if(type == TimeWidgetType.Stopwatch)
      return stopwatchWidgetDescription;

    if(type == TimeWidgetType.TimerWidget)
      return timerWidgetDescription;
  }

  static getTimeWidgetName(TimeWidgetType type){
    if(type == TimeWidgetType.ClockWidget)
      return clockWidgetName;

    if(type == TimeWidgetType.Stopwatch)
      return stopWatchWidgetName;

    if(type == TimeWidgetType.TimerWidget)
      return timerWidgetName;
  }

}
