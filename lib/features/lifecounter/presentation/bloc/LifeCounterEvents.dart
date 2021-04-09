
import 'package:congrega/features/lifecounter/model/PlayerPoints.dart';
import 'package:equatable/equatable.dart';

import '../../model/Player.dart';
import 'LifeCounterState.dart';

abstract class LifeCounterEvent extends Equatable {
  const LifeCounterEvent();

  @override
  List<Object> get props => [];
}

class GameUpdated extends LifeCounterEvent {
  const GameUpdated(this.status);

  final GameStatus status;

  @override
  List<Object> get props => [status];
}

class GamePlayerPointsChanged extends LifeCounterEvent {
  const GamePlayerPointsChanged(this.player, this.points);

  final Player player;
  final PlayerPoints points;

  @override
  List<Object> get props => [player, points];
}

class GamePlayerPointsAdded extends LifeCounterEvent {
  const GamePlayerPointsAdded(this.player, this.points);

  final Player player;
  final PlayerPoints points;

  @override
  List<Object> get props => [player, points];
}
class GamePlayerPointsRemoved extends LifeCounterEvent {
  const GamePlayerPointsRemoved(this.player, this.points);

  final Player player;
  final PlayerPoints points;

  @override
  List<Object> get props => [player, points];
}
