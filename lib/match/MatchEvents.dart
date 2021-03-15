import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:equatable/equatable.dart';

class MatchEvent extends Equatable {
  const MatchEvent();
  
  @override
  List<Object> get props => [];
}

class MatchPlayerQuitsGame extends MatchEvent {
  const MatchPlayerQuitsGame(this.player);
  
  final Player player;

  @override
  List<Object> get props => [player];
}

class MatchPlayerLeaveMatch extends MatchEvent {
  const MatchPlayerLeaveMatch(this.player);

  final Player player;

  @override
  List<Object> get props => [player];
}

class MatchPlayerWinsGame extends MatchEvent {
  const MatchPlayerWinsGame(this.player);

  final Player player;

  @override
  List<Object> get props => [player];
}