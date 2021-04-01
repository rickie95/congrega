
import 'package:congrega/features/lifecounter/model/PlayerPoints.dart';
import 'package:equatable/equatable.dart';

import '../../model/Player.dart';
import 'GameState.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class GameStatusChanged extends GameEvent {
  const GameStatusChanged(this.status);

  final GameStatus status;

  @override
  List<Object> get props => [status];
}

class GamePlayerQuits extends GameEvent {
  const GamePlayerQuits(this.player);
  
  final Player player;
  
  @override
  List<Object> get props => [player];
}

class GamePlayerPointsChanged extends GameEvent {
  const GamePlayerPointsChanged(this.player, this.points);

  final Player player;
  final PlayerPoints points;

  @override
  List<Object> get props => [player, points];
}

class GamePlayerPointsAdded extends GameEvent {
  const GamePlayerPointsAdded(this.player, this.points);

  final Player player;
  final PlayerPoints points;

  @override
  List<Object> get props => [player, points];
}
class GamePlayerPointsRemoved extends GameEvent {
  const GamePlayerPointsRemoved(this.player, this.points);

  final Player player;
  final PlayerPoints points;

  @override
  List<Object> get props => [player, points];
}
