import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:equatable/equatable.dart';

import '../../model/Player.dart';

enum GameStatus { unknown, inProgress, ended }

class LifeCounterState extends Equatable {
  const LifeCounterState(
      {this.status = GameStatus.unknown, required this.user, required this.opponent});

  final Player user;
  final Player opponent;
  final GameStatus status;

  Player opponentOf(User user) {
    return this.user.id == user.id ? this.opponent : this.user;
  }

  Player getUser(User user) {
    return this.user.id == user.id ? this.user : this.opponent;
  }

  const LifeCounterState.unknown()
      : this.status = GameStatus.unknown,
        this.user = Player.empty,
        this.opponent = Player.empty;

  LifeCounterState copyWith({GameStatus? status, Player? user, Player? opponent}) {
    return LifeCounterState(
        status: status ?? this.status,
        user: user ?? this.user,
        opponent: opponent ?? this.opponent);
  }

  @override
  List<Object> get props => [status, user, opponent];
}
