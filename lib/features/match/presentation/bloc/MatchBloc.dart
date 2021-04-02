import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:congrega/features/match/model/Match.dart';

import '../../data/MatchController.dart';
import 'MatchEvents.dart';
import 'MatchState.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState>{
  MatchBloc({
    required this.matchController
  }) : super(const MatchState.unknown()) {
    _matchStatusObserver = matchController.status.listen((status) => add(MatchStatusChanged(status)));
  }

  late StreamSubscription<MatchStatus> _matchStatusObserver;
  final MatchController matchController;

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
    Match updatedMatch = matchController.playerQuitsGame(state.match, event.player);
    return state.copyWith(
        status: (state.opponentScore > 1 || state.userScore > 1) ? MatchStatus.ended : MatchStatus.inProgress,
        match: updatedMatch
    );
  }

  MatchState _mapPlayerLeaveMatch(MatchPlayerLeaveMatch event, MatchState state) {
    Match updatedMatch = matchController.playerResign(state.match, event.player);
    return state.copyWith(
        status:  MatchStatus.ended,
        match: updatedMatch,
    );
  }

  MatchState _mapPlayerWinsGameToState(MatchPlayerWinsGame event, MatchState state) {
    Match updatedMatch = matchController.playerWinsGame(state.match, event.player);
    return state.copyWith(
        status: MatchStatus.inProgress,
        match: updatedMatch
    );
  }

}