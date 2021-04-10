import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:equatable/equatable.dart';

enum MatchType { tournament, offline }

class Match extends Equatable {

  const Match({
    this.id = '-',
    this.type = MatchType.offline,
    required this.user,
    required this.opponent,
    this.userScore = 0,
    this.opponentScore = 0,
  });

  static const empty = Match(user: Player.empty, opponent: Player.empty);

  final String id;
  final MatchType type;
  final Player user;
  final Player opponent;
  final int userScore;
  final int opponentScore;

  Match copyWith({
    String? id,
    MatchType? type,
    Player? user,
    Player? opponent,
    int? userScore,
    int? opponentScore
  }){
    return Match(
      id: id ?? this.id,
      type: type ?? this.type,
      user: user ?? this.user,
      opponent: opponent ?? this.opponent,
      userScore: userScore ?? this.userScore,
      opponentScore: opponentScore ?? this.opponentScore
    );
  }

  Map<String, dynamic> toJson() => {
      "id" : this.id,
      "type" : this.type.toString(),
      "user" : this.user.toJson(),
      "opponent" : this.opponent.toJson(),
      "userScore" : this.userScore,
      "opponentScore" : this.opponentScore,
  };

  factory Match.fromJson(Map<String, dynamic> jsonObj){
    return Match(
      id: jsonObj['id'],
      type: getMatchTypeFromJson(jsonObj['type']),
      user: Player.fromJson(jsonObj['user']),
      opponent: Player.fromJson(jsonObj['opponent']),
      userScore: jsonObj['userScore'],
      opponentScore: jsonObj['opponentScore']
    );
  }

  static MatchType getMatchTypeFromJson(String encoded){
    if(encoded == MatchType.offline.toString())
      return MatchType.offline;

    if(encoded == MatchType.tournament.toString())
      return MatchType.tournament;

    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [id];

}