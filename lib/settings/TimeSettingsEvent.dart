import 'package:congrega/features/lifecounter/presentation/widgets/timeWidget/TimeWidget.dart';
import 'package:equatable/equatable.dart';

class TimeSettingsEvent extends Equatable {
  const TimeSettingsEvent();

  @override
  List<Object> get props => [];
}

class TimeWidgetChanged extends TimeSettingsEvent {
  const TimeWidgetChanged(this.timeWidgetType);

  final TimeWidgetType timeWidgetType;

  @override
  List<Object> get props => [timeWidgetType];
}

class TimeWidgetReset extends TimeSettingsEvent {
  const TimeWidgetReset();

  @override
  List<Object> get props => [];
}

class TimeWidgetPaused extends TimeSettingsEvent {
  const TimeWidgetPaused();

  @override
  List<Object> get props => [];
}

class TimeWidgetResumed extends TimeSettingsEvent {
  const TimeWidgetResumed();

  @override
  List<Object> get props => [];
}

class TimeWidgetPausedOrResumed extends TimeSettingsEvent {
  const TimeWidgetPausedOrResumed();

  @override
  List<Object> get props => [];
}

class TimeDurationChanged extends TimeSettingsEvent {
  const TimeDurationChanged(this.duration);

  final Duration duration;

  @override
  List<Object> get props => [duration];
}

