import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:congrega/features/match/model/Match.dart';
import 'package:equatable/equatable.dart';

enum MatchStatus {unknown, inProgress, ended}
enum MatchType { tournament, offline  }

class MatchState extends Equatable {

  const MatchState({
    this.status = MatchStatus.unknown,
    required this.match,
  });

  const MatchState.unknown() :
        this.status = MatchStatus.unknown,
        this.match = Match.empty;

  final MatchStatus status;
  final Match match;

  MatchState copyWith({
    MatchStatus? status,
    Match? match
  }){
    return MatchState(
        status: status ?? this.status,
        match: match ?? this.match
    );
  }
  
  Player get opponent => this.match.opponent;
  Player get user => this.match.user;
  String get opponentUsername => this.match.opponent.username;
  String get userUsername => this.match.user.username;
  int get opponentScore => this.match.opponentScore;
  int get userScore => this.match.userScore;

  @override
  List<Object> get props => [status, match];

}