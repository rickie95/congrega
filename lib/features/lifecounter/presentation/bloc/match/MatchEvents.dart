import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:congrega/features/lifecounter/model/Match.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/match/MatchState.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:equatable/equatable.dart';

class MatchEvent extends Equatable {
  const MatchEvent();

  @override
  List<Object> get props => [];
}

class PlayerQuitsGame extends MatchEvent {
  const PlayerQuitsGame(this.player);

  final Player player;

  @override
  List<Object> get props => [player];
}

class PlayerLeavesMatch extends MatchEvent {
  const PlayerLeavesMatch(this.player);

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

class MatchAvailable extends MatchEvent {
  const MatchAvailable();

  @override
  List<Object> get props => [];
}

class GameUpdated extends MatchEvent {
  const GameUpdated();

  @override
  List<Object> get props => [];
}

class MatchStatusChanged extends MatchEvent {
  const MatchStatusChanged(this.status);

  final MatchStatus status;

  @override
  List<Object> get props => [status];
}

class CreateOffline1V1Match extends MatchEvent {
  final User opponent;

  const CreateOffline1V1Match({required this.opponent});

  @override
  List<Object> get props => [opponent];
}

class Online1vs1Match extends MatchEvent {
  final Match match;

  const Online1vs1Match({required this.match});
  @override
  List<Object> get props => [match];
}

class FetchOnline1vs1Match extends MatchEvent {
  final User opponent;
  final String matchId;

  const FetchOnline1vs1Match({required this.opponent, required this.matchId});

  @override
  List<Object> get props => [opponent, matchId];
}
