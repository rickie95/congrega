import 'package:congrega/lifecounter/GameEvents.dart';
import 'package:congrega/lifecounter/GameState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'model/Player.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc(GameState state) : super(state);

  // Need reference to MatchBloc/Service

  @override
  Stream<GameState> mapEventToState(GameEvent event) async* {
    if (event is GamePlayerPointsChanged) {
      yield _mapPlayerPointsChangedToState(event, state);
    } else if (event is GamePlayerQuits) {
      yield _mapPlayerQuitsToState(event, state);
    } else if (event is GamePlayerPointsAdded) {
      yield _mapPlayerPointsAddedToState(event, state);
    } else if (event is GamePlayerPointsRemoved) {
      yield _mapPlayerPointsRemovedToState(event, state);
    }
  }

  GameState _mapPlayerPointsChangedToState(GamePlayerPointsChanged event,
      GameState state) {
    final PlayerPoints pointsToBeUpdated = event.points;
    List<PlayerPoints> updatedList = [];
    for (PlayerPoints pp in event.player.points)
      pointsToBeUpdated.isTheSameTypeOf(pp)
          ? updatedList.add(pointsToBeUpdated)
          : updatedList.add(pp);

    final Player playerToBeUpdated = event.player.copyWith(list: updatedList);

    return state.copyWith(
      user: playerToBeUpdated.id == state.user.id ? playerToBeUpdated : state
          .user,
      opponent: playerToBeUpdated.id == state.opponent.id
          ? playerToBeUpdated
          : state.opponent,
    );
  }

  GameState _mapPlayerPointsAddedToState(GamePlayerPointsAdded event,
      GameState state) {
    List<PlayerPoints> grownList = event.player.points.toList();
    grownList.add(event.points);

    final Player playerToBeUpdated = event.player.copyWith(list: grownList);

    return state.copyWith(
        user: playerToBeUpdated.id == state.user.id ? playerToBeUpdated : state
            .user,
        opponent: playerToBeUpdated.id == state.opponent.id
            ? playerToBeUpdated
            : state.opponent
    );
  }

  GameState _mapPlayerPointsRemovedToState(GamePlayerPointsRemoved event,
      GameState state) {
    List<PlayerPoints> reducedList = event.player.points.toList();
    reducedList.remove(event.points);

    final Player playerToBeUpdated = event.player.copyWith(list: reducedList);

    return state.copyWith(
        user: playerToBeUpdated.id == state.user.id ? playerToBeUpdated : state
            .user,
        opponent: playerToBeUpdated.id == state.opponent.id
            ? playerToBeUpdated
            : state.opponent
    );
  }

  GameState _mapPlayerQuitsToState(GamePlayerQuits event, GameState state) {
    final BigInt quittingPlayerId = event.player.id;
    // TODO: fire event on MatchBloc/Service
    // matchBloc.playerQuits(quittingPlayerId)
    return state.copyWith(
        status: GameStatus.ended
    );
  }
}
