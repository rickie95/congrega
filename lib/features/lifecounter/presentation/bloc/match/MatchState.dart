import 'package:congrega/features/lifecounter/model/Game.dart';
import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:congrega/features/lifecounter/model/Match.dart';
import 'package:equatable/equatable.dart';

enum MatchStatus {unknown, inProgress, ended, updated}

class MatchState extends Equatable {

  const MatchState({
    this.status = MatchStatus.unknown,
    required this.match,
    required this.game
  });

  const MatchState.unknown() :
        this.status = MatchStatus.unknown,
        this.match = Match.empty,
        this.game = Game.empty;

  final MatchStatus status;
  final Match match;
  final Game game;

  MatchState copyWith({
    MatchStatus? status,
    Match? match,
    Game? game
  }){
    return MatchState(
        status: status ?? this.status,
        match: match ?? this.match,
        game: game ?? this.game
    );
  }
  
  Player get opponent => this.match.opponent;
  Player get user => this.match.user;
  String get opponentUsername => this.match.opponent.username;
  String get userUsername => this.match.user.username;
  int get opponentScore => this.match.opponentScore;
  int get userScore => this.match.userScore;

  @override
  List<Object> get props => [status, match, match.opponentScore, match.userScore];

}