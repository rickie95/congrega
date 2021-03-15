import 'package:congrega/match/MatchEvents.dart';
import 'package:congrega/match/MatchState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState>{
  MatchBloc({initialState}) : super(initialState);

  @override
  Stream<MatchState> mapEventToState(MatchEvent event) async* {
    if (event is MatchPlayerQuitsGame) {
      yield _mapPlayerQuitsGameToState(event, state);
    } else if(event is MatchPlayerLeaveMatch) {
      yield _mapPlayerLeaveMatch(event, state);
    } else if(event is MatchPlayerWinsGame) {
      yield _mapPlayerWinsGameToState(event, state);
    }
  }

  MatchState _mapPlayerQuitsGameToState(MatchPlayerQuitsGame event, MatchState state){
    return state.copyWith(
        status: (state.opponentScore > 1 || state.userScore > 1) ? MatchStatus.ended : MatchStatus.inProgress,
        opponentScore: event.player.id == state.user.id ? state.opponentScore + 1 : state.opponentScore,
        userScore: event.player.id == state.opponent.id ? state.userScore + 1: state.userScore
    );
  }

  MatchState _mapPlayerLeaveMatch(MatchPlayerLeaveMatch event, MatchState state) {
    return state.copyWith(
        status:  MatchStatus.ended,
        opponentScore: event.player.id == state.user.id ? 2 : 0,
        userScore: event.player.id == state.opponent.id ? 2: 0
    );
  }

  MatchState _mapPlayerWinsGameToState(MatchPlayerWinsGame event, MatchState state) {
    return state.copyWith(
        status: MatchStatus.inProgress,
        opponentScore: event.player.id == state.opponent.id ? state.opponentScore + 1 : state.opponentScore,
        userScore: event.player.id == state.user.id ? state.userScore + 1: state.userScore
    );
  }




}