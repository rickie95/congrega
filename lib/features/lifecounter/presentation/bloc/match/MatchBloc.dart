import 'dart:async';

import 'package:congrega/features/lifecounter/model/Game.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/LifeCounterState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:congrega/features/lifecounter/model/Match.dart';

import '../../../data/match/MatchController.dart';
import 'MatchEvents.dart';
import 'MatchState.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  MatchBloc({required this.matchController}) : super(const MatchState.unknown()) {
    _matchStatusObserver =
        matchController.status.listen((MatchStatus status) => add(StatusChanged(status)));
    _gameStatusObserver = matchController.gameStatus.listen((GameStatus gameAvailable) {
      if (gameAvailable == GameStatus.inProgress) add(GameUpdated());
    });
  }

  late StreamSubscription<MatchStatus> _matchStatusObserver;
  late StreamSubscription<GameStatus> _gameStatusObserver;
  final MatchController matchController;

  bool isAnOfflineMatch() => state.match.type == MatchType.offline;

  @override
  Stream<MatchState> mapEventToState(MatchEvent event) async* {
    if (event is StatusChanged) {
      yield await _mapMatchStatusChangedToState(event, state);
    } else if (event is CreateOffline1V1Match) {
      yield await _mapCreate1vs1MatchToState(event, state);
    } else if (event is Online1vs1Match) {
      yield await _mapCreate1vs1OnlineMatchToState(event, state);
    } else if (event is FetchOnline1vs1Match) {
      yield await _mapFetch1vs1OnlineMatchToState(event, state);
    } else if (event is GameUpdated) {
      yield await _mapGameAvailableToState(event, state);
    } else if (event is PlayerQuitsGame) {
      yield _mapPlayerQuitsGameToState(event, state);
    } else if (event is PlayerLeavesMatch) {
      yield await _mapPlayerLeaveMatch(event, state);
    }
  }

  Future<MatchState> _mapMatchStatusChangedToState(StatusChanged event, MatchState state) async {
    if (event.status == MatchStatus.updated || event.status == MatchStatus.inProgress)
      return await matchController
          .getCurrentMatch()
          .then((Match match) => state.copyWith(match: match, status: MatchStatus.inProgress));

    return state.copyWith(status: event.status);
  }

  Future<MatchState> _mapGameAvailableToState(GameUpdated event, MatchState state) async {
    return await matchController
        .getCurrentGame()
        .then((Game recoveredGame) => state.copyWith(game: recoveredGame));
  }

  MatchState _mapPlayerQuitsGameToState(PlayerQuitsGame event, MatchState state) {
    Match updatedMatch = matchController.playerQuitsGame(state.match, event.player);
    return state.copyWith(match: updatedMatch);
  }

  Future<MatchState> _mapPlayerLeaveMatch(PlayerLeavesMatch event, MatchState state) async {
    return await matchController
        .playerResign(state.match, event.player)
        .then((updatedMatch) => MatchState.unknown());
  }

  Future<MatchState> _mapCreate1vs1MatchToState(
      CreateOffline1V1Match event, MatchState state) async {
    return await matchController
        .newOfflineMatch(opponent: event.opponent)
        .then((Match newMatch) => state.copyWith(match: newMatch, status: MatchStatus.inProgress));
  }

  Future<MatchState> _mapCreate1vs1OnlineMatchToState(
      Online1vs1Match event, MatchState state) async {
    return state.copyWith(match: event.match, status: MatchStatus.inProgress);
  }

  Future<MatchState> _mapFetch1vs1OnlineMatchToState(
      FetchOnline1vs1Match event, MatchState state) async {
    return await matchController
        .fetchOnlineMatch(event.opponent, event.matchId)
        .then((Match newMatch) => state.copyWith(match: newMatch, status: MatchStatus.inProgress));
  }

  @override
  Future<void> close() {
    _matchStatusObserver.cancel();
    _gameStatusObserver.cancel();
    return super.close();
  }
}
