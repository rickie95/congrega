
import 'package:congrega/features/lifecounter/presentation/widgets/timeWidgets/widgets/TimeWidget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'TimeSettingsEvent.dart';
import 'TimeSettingsState.dart';

class TimeSettingsBloc extends Bloc<TimeSettingsEvent, TimeSettingsState> {
  TimeSettingsBloc({TimeSettingsState? initialState}) :
        super(initialState ?? const TimeSettingsState());

  @override
  Stream<TimeSettingsState> mapEventToState(TimeSettingsEvent event) async* {
    if(event is TimeWidgetChanged){
      yield await _mapTimeWidgetChangedToState(event, state);
    } else if (event is TimeWidgetReset){
      yield _mapTimeWidgetResetToState(event, state);
    } else if (event is TimeWidgetPaused){
      yield _mapTimeWidgetPausedToState(event, state);
    } else if (event is TimeWidgetResumed){
      yield _mapTimeWidgetResumedToState(event, state);
    } else if (event is TimeDurationChanged) {
      yield _mapTimeDurationChangedToState(event, state);
    } else if (event is TimeWidgetPausedOrResumed) {
      yield _mapTimePausedOrResumedToState(event, state);
    }
  }

  Future<TimeSettingsState> _mapTimeWidgetChangedToState(TimeWidgetChanged event, TimeSettingsState state) async {
    final TimeWidgetType type = event.timeWidgetType;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('timeWidgetType', type.toString());

    return state.copyWith( timeWidgetType: type );
  }

  TimeSettingsState _mapTimeWidgetResetToState(TimeWidgetReset event, TimeSettingsState state) {
    return state.copyWith(
      status: TimeWidgetStatus.stopped
    );
  }

  TimeSettingsState _mapTimeWidgetPausedToState(TimeWidgetPaused event, TimeSettingsState state){
    return state.copyWith(
      status: TimeWidgetStatus.paused
    );
  }

  TimeSettingsState _mapTimeWidgetResumedToState(TimeWidgetResumed event, TimeSettingsState state){
    return state.copyWith(
      status: TimeWidgetStatus.running
    );
  }

  TimeSettingsState _mapTimeDurationChangedToState(TimeDurationChanged event, TimeSettingsState state) {
    return state.copyWith(
      status: TimeWidgetStatus.stopped,
      duration: event.duration,
    );
  }

  TimeSettingsState _mapTimePausedOrResumedToState(TimeWidgetPausedOrResumed event, TimeSettingsState state) {
    return state.copyWith(
      status: state.status == TimeWidgetStatus.running ? TimeWidgetStatus.paused : TimeWidgetStatus.running
    );
  }

}
