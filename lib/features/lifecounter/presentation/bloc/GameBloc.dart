import 'dart:async';

import 'package:congrega/features/lifecounter/data/Game.dart';
import 'package:congrega/features/lifecounter/data/GameRepository.dart';
import 'package:congrega/features/lifecounter/model/PlayerPoints.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/GameEvents.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/GameState.dart';
import 'package:congrega/features/match/presentation/bloc/MatchBloc.dart';
import 'package:congrega/features/match/presentation/bloc/MatchEvents.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/Player.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({
    required this.matchBloc,
    required this.gameRepository,
  }) : super(const GameState.unknown()) {
    _gameStatusObserver = gameRepository.status.listen((status) => add(GameStatusChanged(status)));
  }

  late StreamSubscription<GameStatus> _gameStatusObserver;
  final GameRepository gameRepository;
  final MatchBloc matchBloc;

  @override
  Stream<GameState> mapEventToState(GameEvent event) async* {
    if(event is GameStatusChanged){
      yield await _mapGameStatusChangedToState(event.status, state);
    } else if (event is GamePlayerPointsChanged) {
      yield _mapPlayerPointsChangedToState(event, state);
    } else if (event is GamePlayerQuits) {
      yield _mapPlayerQuitsToState(event, state);
    } else if (event is GamePlayerPointsAdded) {
      yield _mapPlayerPointsAddedToState(event, state);
    } else if (event is GamePlayerPointsRemoved) {
      yield _mapPlayerPointsRemovedToState(event, state);
    }
  }

  Future<GameState> _mapGameStatusChangedToState(GameStatus status, GameState state) async {
    switch(status){
      case(GameStatus.ended):
        gameRepository.newGame();
        return state.copyWith(status: GameStatus.unknown);
      case(GameStatus.inProgress):
        return await gameRepository.recoverGame().then((Game game) => state.copyWith(
          user: game.team[0],
          opponent: game.opponents[0],
          status: GameStatus.inProgress,
        ));
      default:
        return state.copyWith(status: GameStatus.unknown);
    }
  }

  GameState _mapPlayerPointsChangedToState(GamePlayerPointsChanged event, GameState state) {
    final PlayerPoints pointsToBeUpdated = event.points;
    Set<PlayerPoints> updatedList = {};
    for (PlayerPoints pp in event.player.points)
      pointsToBeUpdated.isTheSameTypeOf(pp.runtimeType) ? updatedList.add(pointsToBeUpdated) : updatedList.add(pp);

    final Player playerToBeUpdated = event.player.copyWith(list: updatedList);
    
    return _updatedGameState(playerToBeUpdated);
  }

  GameState _mapPlayerPointsAddedToState(GamePlayerPointsAdded event, GameState state) {
    Set<PlayerPoints> grownList = event.player.points.toSet();
    grownList.add(event.points);

    final Player playerToBeUpdated = event.player.copyWith(list: grownList);

    return _updatedGameState(playerToBeUpdated);
  }

  GameState _mapPlayerPointsRemovedToState(GamePlayerPointsRemoved event, GameState state) {
    Set<PlayerPoints> reducedList = event.player.points.toSet();
    reducedList.remove(event.points);

    final Player playerToBeUpdated = event.player.copyWith(list: reducedList);

    return _updatedGameState(playerToBeUpdated);
  }

  GameState _mapPlayerQuitsToState(GamePlayerQuits event, GameState state) {
    matchBloc.add(MatchPlayerQuitsGame(event.player));
    gameRepository.endGame();
    return state.copyWith(status: GameStatus.unknown);
  }

  GameState _updatedGameState(Player updatedPlayer){
    Game updatedGame = new Game(
        opponents: [updatedPlayer.id == state.opponent.id ? updatedPlayer : state.opponent],
        team: [updatedPlayer.id == state.user.id ? updatedPlayer : state.user]
    );
    gameRepository.updateGame(updatedGame);

    return state.copyWith(
      user: updatedGame.team[0],
      opponent: updatedGame.opponents[0],
    );
  }

  @override
  Future<void> close(){
    _gameStatusObserver.cancel();
    return super.close();
  }
}
