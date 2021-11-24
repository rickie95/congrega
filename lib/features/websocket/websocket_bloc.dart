import 'package:congrega/features/websocket/websocket_events.dart';
import 'package:congrega/features/websocket/websocket_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LifeCounterLiveUpdateBloc extends Bloc<LifeCounterLiveUpdateEvent, LifeCounterUpdateState> {
  LifeCounterLiveUpdateBloc() : super(LifeCounterUpdateState(score: 20));

  @override
  Stream<LifeCounterUpdateState> mapEventToState(LifeCounterLiveUpdateEvent event) async* {
    if (event is MessageReceived) {
      yield mapMessageReceivedToState(event);
    } else if (event is SendMessage) {
      yield mapSendMessageToState(event);
    } else if (event is OpponentPointsUpdate) {
      yield _mapOpponentPointUpdateToState(event);
    }
  }

  LifeCounterUpdateState mapMessageReceivedToState(MessageReceived event) {
    return state.copyWith();
  }

  LifeCounterUpdateState mapSendMessageToState(SendMessage event) {
    return state.copyWith();
  }

  LifeCounterUpdateState _mapOpponentPointUpdateToState(OpponentPointsUpdate event) {
    print("Opponent updated his LF");
    return state.copyWith(score: event.points);
  }
}
