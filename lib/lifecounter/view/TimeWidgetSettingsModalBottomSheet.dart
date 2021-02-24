import 'package:congrega/lifecounter/view/timeWidget/TimeWidget.dart';
import 'package:congrega/settings/TimeSettingsBloc.dart';
import 'package:congrega/settings/TimeSettingsEvent.dart';
import 'package:congrega/settings/TimeSettingsState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:settings_ui/settings_ui.dart';

class TimeWidgetSettingsModalBottomSheet extends StatelessWidget {

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  final String settingSectionTitle = 'Time widget settings';

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 10),
    child: _body(context)
    );
  }

  Widget _body(BuildContext context){
    return BlocBuilder<TimeSettingsBloc, TimeSettingsState>(
        buildWhen: (previous, current) => (previous.timeWidgetType != current.timeWidgetType) || (previous.duration != current.duration),
        builder: (context, state) {
          return SettingsList(
              backgroundColor: Colors.white,
              sections: [
                SettingsSection(
                    titleTextStyle: TextStyle(fontSize: 16, color: Color.fromRGBO(0, 0, 0, 0.54)),
                    title: settingSectionTitle,
                    tiles: [
                      SettingsTile(
                          title: 'Widget type',
                          subtitle: TimeWidget.getTimeWidgetName(state.timeWidgetType),
                          leading: Icon(Icons.access_time),
                          onPressed: (context) {
                            showModalBottomSheet(context: context, builder: (_) {
                              return BlocProvider.value(
                                  value: BlocProvider.of<TimeSettingsBloc>(context),
                                  child: ClockWidgetModalBottomSheet()
                              );
                            });
                          }),

                      SettingsTile(
                        title: 'Countdown starting time',
                        subtitle: format(state.duration),
                        enabled: (state.timeWidgetType == TimeWidgetType.TimerWidget),
                        leading: Icon(Icons.hourglass_top),
                        onPressed: (context) async {

                          Duration duration = await showDurationPicker(
                            context: context,
                            initialTime: state.duration,
                          );

                          context.read<TimeSettingsBloc>().add(TimeDurationChanged(duration));
                        },
                      ),

                      SettingsTile(
                        enabled: (state.timeWidgetType == TimeWidgetType.Stopwatch ||
                            state.timeWidgetType == TimeWidgetType.TimerWidget),
                        title: 'Reset timer',
                        leading: Icon(Icons.timer),
                        onPressed: (context) { context.read<TimeSettingsBloc>().add(TimeWidgetReset()); },
                      )
                    ]
                )
              ]
          );

        }
    );
  }
}

class ClockWidgetModalBottomSheet extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimeSettingsBloc, TimeSettingsState>(
        buildWhen: (previous, current) => previous.timeWidgetType != current.timeWidgetType,
        builder: (context, state) {
          return SettingsList(
              sections: [
                SettingsSection(
                    title: 'Clock widget type',
                    tiles: [
                      SettingsTile(
                        title: TimeWidget.getTimeWidgetName(TimeWidgetType.ClockWidget),
                        subtitle: TimeWidget.getTimeWidgetDescription(TimeWidgetType.ClockWidget),
                        trailing: state.timeWidgetType == TimeWidgetType.ClockWidget ? Icon(Icons.check, color: Colors.blue) : null,
                        onPressed: (context) => context.read<TimeSettingsBloc>().add(TimeWidgetChanged(TimeWidgetType.ClockWidget)),
                      ),
                      SettingsTile(
                        title: TimeWidget.getTimeWidgetName(TimeWidgetType.Stopwatch),
                        subtitle: TimeWidget.getTimeWidgetDescription(TimeWidgetType.Stopwatch),
                        trailing: state.timeWidgetType == TimeWidgetType.Stopwatch ? Icon(Icons.check, color: Colors.blue) : null,
                        onPressed: (context) => context.read<TimeSettingsBloc>().add(TimeWidgetChanged(TimeWidgetType.Stopwatch)),
                      ),
                      SettingsTile(
                        title: TimeWidget.getTimeWidgetName(TimeWidgetType.TimerWidget),
                        subtitle: TimeWidget.getTimeWidgetDescription(TimeWidgetType.TimerWidget),
                        trailing: state.timeWidgetType == TimeWidgetType.TimerWidget ? Icon(Icons.check, color: Colors.blue) : null,
                        onPressed: (context) => context.read<TimeSettingsBloc>().add(TimeWidgetChanged(TimeWidgetType.TimerWidget)),
                      ),
                    ]
                )
              ]
          );
        });
  }
}
