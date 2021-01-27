import 'package:congrega/lifecounter/model/Player.dart';
import 'package:equatable/equatable.dart';

enum MatchStatus {unknown, inProgress, ended}

class MatchState extends Equatable {

  const MatchState({
    this.status = MatchStatus.unknown,
    this.user,
    this.opponent,
    this.userScore = 0,
    this.opponentScore = 0,
});

  final MatchStatus status;
  final Player user;
  final Player opponent;
  final int userScore;
  final int opponentScore;

  MatchState copyWith({MatchStatus status, Player user, Player opponent, int userScore, int opponentScore}){
    return MatchState(
        status: status ?? this.status,
        user: user ?? this.user,
        opponent: opponent ?? this.opponent,
        userScore: userScore ?? this.status,
        opponentScore: opponentScore ?? this.status
    );
  }

  @override
  List<Object> get props => [status, user, opponent, userScore, opponentScore];

}