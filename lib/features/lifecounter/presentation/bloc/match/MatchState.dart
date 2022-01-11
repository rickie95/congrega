import 'package:congrega/features/lifecounter/model/Game.dart';
import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:congrega/features/lifecounter/model/Match.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:equatable/equatable.dart';

enum MatchStatus { unknown, inProgress, ended, updated }

class MatchState extends Equatable {
  const MatchState({this.status = MatchStatus.unknown, required this.match, required this.game});

  const MatchState.unknown()
      : this.status = MatchStatus.unknown,
        this.match = Match.empty,
        this.game = Game.empty;

  final MatchStatus status;
  final Match match;
  final Game game;

  MatchState copyWith({MatchStatus? status, Match? match, Game? game}) {
    return MatchState(
        status: status ?? this.status, match: match ?? this.match, game: game ?? this.game);
  }

  Player opponent(User user) => this.match.opponentOf(user);
  Player user(User user) => this.match.getUserAsPlayer(user);
  int opponentScore(User user) =>
      user.id == this.match.playerOne.id ? this.match.playerTwoScore : this.match.playerOneScore;
  int userScore(User user) =>
      user.id == this.match.playerOne.id ? this.match.playerOneScore : this.match.playerTwoScore;

  @override
  List<Object> get props => [status, match, match.playerTwoScore, match.playerOneScore];
}
