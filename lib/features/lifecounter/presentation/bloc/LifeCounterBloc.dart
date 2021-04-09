import 'dart:async';

import 'package:congrega/features/lifecounter/model/Game.dart';
import 'package:congrega/features/lifecounter/data/game/GameRepository.dart';
import 'package:congrega/features/lifecounter/model/PlayerPoints.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/LifeCounterEvents.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/LifeCounterState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/Player.dart';

class LifeCounterBloc extends Bloc<LifeCounterEvent, LifeCounterState> {
  LifeCounterBloc({
    required this.gameRepository,
  }) : super(const LifeCounterState.unknown()) {
    _gameStatusObserver = gameRepository.status.listen((GameStatus status) => add(GameUpdated(status)));
  }

  late StreamSubscription<GameStatus> _gameStatusObserver;
  final GameRepository gameRepository;

  @override
  Stream<LifeCounterState> mapEventToState(LifeCounterEvent event) async* {
    if(event is GameUpdated){
      yield await _mapGameUpdatedToState(event, state);
    } else if (event is GamePlayerPointsChanged) {
      yield _mapPlayerPointsChangedToState(event, state);
    } else if (event is GamePlayerPointsAdded) {
      yield _mapPlayerPointsAddedToState(event, state);
    } else if (event is GamePlayerPointsRemoved) {
      yield _mapPlayerPointsRemovedToState(event, state);
    }
  }

  Future<LifeCounterState> _mapGameUpdatedToState(GameUpdated event, LifeCounterState state) async {
    if (event.status == GameStatus.inProgress)
      return await gameRepository.getCurrentGame()
          .then((Game game) => state.copyWith(
          user: game.team[0],
          opponent: game.opponents[0],
          status: GameStatus.inProgress
      ));
    return state;
  }

  LifeCounterState _mapPlayerPointsChangedToState(GamePlayerPointsChanged event, LifeCounterState state) {
    final PlayerPoints pointsToBeUpdated = event.points;
    Set<PlayerPoints> updatedList = {};
    for (PlayerPoints pp in event.player.points)
      pointsToBeUpdated.isTheSameTypeOf(pp.runtimeType) ? updatedList.add(pointsToBeUpdated) : updatedList.add(pp);

    final Player playerToBeUpdated = event.player.copyWith(list: updatedList);

    return _updatedGameState(playerToBeUpdated);
  }

  LifeCounterState _mapPlayerPointsAddedToState(GamePlayerPointsAdded event, LifeCounterState state) {
    Set<PlayerPoints> grownList = event.player.points.toSet();
    grownList.add(event.points);

    final Player playerToBeUpdated = event.player.copyWith(list: grownList);

    return _updatedGameState(playerToBeUpdated);
  }

  LifeCounterState _mapPlayerPointsRemovedToState(GamePlayerPointsRemoved event, LifeCounterState state) {
    Set<PlayerPoints> reducedList = event.player.points.toSet();
    reducedList.remove(event.points);

    final Player playerToBeUpdated = event.player.copyWith(list: reducedList);

    return _updatedGameState(playerToBeUpdated);
  }

  LifeCounterState _updatedGameState(Player updatedPlayer){
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
