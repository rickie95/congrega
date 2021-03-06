import 'package:equatable/equatable.dart';

import 'model/Player.dart';

enum GameStatus {unknown, inProgress, ended}

class GameState extends Equatable {

  const GameState({
    this.status = GameStatus.unknown,
    this.user,
    this.opponent
  });
  
  final Player user;
  final Player opponent;
  final GameStatus status;

  GameState copyWith({GameStatus status, Player user, Player opponent,
    int userScore, int opponentScore}){
    return GameState(
      status: status ?? this.status,
      user: user ?? this.user,
      opponent: opponent ?? this.opponent
    );
  }
  
  @override
  List<Object> get props => [status, user, opponent];

}