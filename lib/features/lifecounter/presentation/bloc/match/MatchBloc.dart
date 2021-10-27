import 'dart:async';

import 'package:congrega/features/lifecounter/data/game/GameRepository.dart';
import 'package:congrega/features/lifecounter/model/Game.dart';
import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/LifeCounterState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:congrega/features/lifecounter/model/Match.dart';

import '../../../data/match/MatchController.dart';
import 'MatchEvents.dart';
import 'MatchState.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  MatchBloc({required this.matchController, required this.gameRepository})
      : super(const MatchState.unknown()) {
    _matchStatusObserver = matchController.status.listen((MatchStatus status) {
      if (status == MatchStatus.updated || status == MatchStatus.inProgress) add(MatchAvailable());
    });
    _gameStatusObserver = gameRepository.status.listen((GameStatus gameAvailable) {
      if (gameAvailable == GameStatus.inProgress) add(GameUpdated());
    });
  }

  late StreamSubscription<MatchStatus> _matchStatusObserver;
  late StreamSubscription<GameStatus> _gameStatusObserver;
  final MatchController matchController;
  final GameRepository gameRepository;

  bool isAnOfflineMatch() => state.match.type == MatchType.offline;

  @override
  Stream<MatchState> mapEventToState(MatchEvent event) async* {
    if (event is MatchAvailable) {
      yield await _mapMatchAvailableToState(event, state);
    } else if (event is Create1V1Match) {
      yield await _mapCreate1vs1MatchToState(event, state);
    } else if (event is GameUpdated) {
      yield await _mapGameAvailableToState(event, state);
    } else if (event is PlayerQuitsGame) {
      yield _mapPlayerQuitsGameToState(event, state);
    } else if (event is PlayerLeavesMatch) {
      yield _mapPlayerLeaveMatch(event, state);
    }
  }

  Future<MatchState> _mapMatchAvailableToState(MatchAvailable event, MatchState state) async {
    return await matchController
        .getCurrentMatch()
        .then((Match match) => state.copyWith(match: match, status: MatchStatus.inProgress));
  }

  Future<MatchState> _mapGameAvailableToState(GameUpdated event, MatchState state) async {
    return await gameRepository
        .getCurrentGame()
        .then((Game recoveredGame) => state.copyWith(game: recoveredGame));
  }

  MatchState _mapPlayerQuitsGameToState(PlayerQuitsGame event, MatchState state) {
    Match updatedMatch = matchController.playerQuitsGame(state.match, event.player);
    return state.copyWith(match: updatedMatch);
  }

  MatchState _mapPlayerLeaveMatch(PlayerLeavesMatch event, MatchState state) {
    Match updatedMatch = matchController.playerResign(state.match, event.player);
    gameRepository.endGame();
    return state.copyWith(match: updatedMatch);
  }

  Future<MatchState> _mapCreate1vs1MatchToState(Create1V1Match event, MatchState state) async {
    return await matchController
        .newOfflineMatch(opponent: event.opponent)
        .then((Match newMatch) => state.copyWith(match: newMatch, status: MatchStatus.inProgress));
  }

  @override
  Future<void> close() {
    _matchStatusObserver.cancel();
    _gameStatusObserver.cancel();
    return super.close();
  }
}
