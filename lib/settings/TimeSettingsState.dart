import 'package:congrega/lifecounter/view/timeWidget/TimeWidget.dart';
import 'package:equatable/equatable.dart';

enum TimeWidgetStatus { running, paused, stopped }

class TimeSettingsState extends Equatable {

  const TimeSettingsState({
    this.status = TimeWidgetStatus.running,
    this.timeWidgetType = TimeWidgetType.ClockWidget,
    this.duration = const Duration(minutes: 50)
  });

  final TimeWidgetStatus status;
  final TimeWidgetType timeWidgetType;
  final Duration duration;

  TimeSettingsState copyWith({TimeWidgetStatus status,
    TimeWidgetType timeWidgetType, Duration duration}){
    return TimeSettingsState(
      status: status ?? this.status,
      timeWidgetType: timeWidgetType ?? this.timeWidgetType,
      duration: duration ?? this.duration
    );
  }

  @override
  List<Object> get props => [status, timeWidgetType];
  
}