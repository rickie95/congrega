import 'dart:async';

import 'package:congrega/features/lifecounter/data/game/game_live_manager.dart';
import 'package:congrega/features/lifecounter/model/Game.dart';
import 'package:congrega/features/lifecounter/data/game/GameRepository.dart';
import 'package:congrega/features/lifecounter/model/PlayerPoints.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/LifeCounterEvents.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/LifeCounterState.dart';
import 'package:congrega/features/users/UserRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';

import '../../model/Player.dart';

class LifeCounterBloc extends Bloc<LifeCounterEvent, LifeCounterState> {
  LifeCounterBloc({required this.gameRepository, required this.gameLiveManager})
      : super(const LifeCounterState.unknown()) {
    _gameStatusObserver =
        gameRepository.status.listen((GameStatus status) => add(GameUpdated(status)));
  }

  late StreamSubscription<GameStatus> _gameStatusObserver;
  final GameRepository gameRepository;
  final GameLiveManager gameLiveManager;

  @override
  Stream<LifeCounterState> mapEventToState(LifeCounterEvent event) async* {
    if (event is GameUpdated) {
      yield await _mapGameUpdatedToState(event, state);
    } else if (event is GamePlayerPointsChanged) {
      yield await _mapPlayerPointsChangedToState(event, state);
    } else if (event is GamePlayerPointsAdded) {
      yield await _mapPlayerPointsAddedToState(event, state);
    } else if (event is GamePlayerPointsRemoved) {
      yield await _mapPlayerPointsRemovedToState(event, state);
    }
  }

  Future<LifeCounterState> _mapGameUpdatedToState(GameUpdated event, LifeCounterState state) async {
    if (event.status == GameStatus.inProgress)
      return await gameRepository
          .getCurrentGame()
          .then((Game game) => Future<Game>(() {
                gameLiveManager.setupWs(game);
                return game;
              }))
          .then((Game game) => state.copyWith(
              user: state.user.id == game.team[0].id ? game.team[0] : game.opponents[0],
              opponent:
                  state.opponent.id == game.opponents[0].id ? game.opponents[0] : game.team[0],
              status: GameStatus.inProgress));
    return state;
  }

  Future<LifeCounterState> _mapPlayerPointsChangedToState(
      GamePlayerPointsChanged event, LifeCounterState state) async {
    final PlayerPoints pointsToBeUpdated = event.points;
    Set<PlayerPoints> updatedList = {};
    for (PlayerPoints pp in event.player.points)
      pointsToBeUpdated.isTheSameTypeOf(pp.runtimeType)
          ? updatedList.add(pointsToBeUpdated)
          : updatedList.add(pp);

    final Player playerToBeUpdated = event.player.copyWith(list: updatedList);
    if (state.getUser(await KiwiContainer().resolve<UserRepository>().getUser()).id ==
            event.player.user.id &&
        pointsToBeUpdated.isTheSameTypeOf(LifePoints))
      gameLiveManager.updateLifePoints(pointsToBeUpdated.value);
    return _updatedGameState(playerToBeUpdated);
  }

  Future<LifeCounterState> _mapPlayerPointsAddedToState(
      GamePlayerPointsAdded event, LifeCounterState state) {
    Set<PlayerPoints> grownList = event.player.points.toSet();
    grownList.add(event.points);

    final Player playerToBeUpdated = event.player.copyWith(list: grownList);

    return _updatedGameState(playerToBeUpdated);
  }

  /// Handles event PlayerPointsRemoved
  Future<LifeCounterState> _mapPlayerPointsRemovedToState(
      GamePlayerPointsRemoved event, LifeCounterState state) {
    Set<PlayerPoints> reducedList = event.player.points.toSet();
    reducedList.remove(event.points);

    final Player playerToBeUpdated = event.player.copyWith(list: reducedList);

    return _updatedGameState(playerToBeUpdated);
  }

  Future<LifeCounterState> _updatedGameState(Player updatedPlayer) async {
    Game currentGame = await gameRepository.getCurrentGame();

    // fixme: meglio un copy with
    Game updatedGame = new Game(id: currentGame.id, opponents: [
      updatedPlayer.id == currentGame.opponents[0].id ? updatedPlayer : currentGame.opponents[0]
    ], team: [
      updatedPlayer.id == currentGame.team[0].id ? updatedPlayer : currentGame.team[0]
    ]);

    gameRepository.updateGame(updatedGame);

    return state.copyWith(
      user: updatedGame.team[0],
      opponent: updatedGame.opponents[0],
    );
  }

  @override
  Future<void> close() {
    _gameStatusObserver.cancel();
    return super.close();
  }
}
