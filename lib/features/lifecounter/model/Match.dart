import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:equatable/equatable.dart';

import 'Game.dart';

enum MatchType { tournament, offline, online }

class Match extends Equatable {
  const Match(
      {this.id = '-',
      this.type = MatchType.offline,
      required this.playerOne,
      required this.playerTwo,
      this.playerOneScore = 0,
      this.playerTwoScore = 0,
      this.gameList = null});

  static const empty = Match(playerOne: Player.empty, playerTwo: Player.empty);

  final String id;
  final MatchType type;
  final Player playerOne;
  final Player playerTwo;
  final int playerOneScore;
  final int playerTwoScore;
  final List<Game>? gameList;

  Match copyWith(
      {String? id,
      MatchType? type,
      Player? user,
      Player? opponent,
      int? userScore,
      int? opponentScore,
      List<Game>? gameList}) {
    return Match(
        id: id ?? this.id,
        type: type ?? this.type,
        playerOne: user ?? this.playerOne,
        playerTwo: opponent ?? this.playerTwo,
        playerOneScore: userScore ?? this.playerOneScore,
        playerTwoScore: opponentScore ?? this.playerTwoScore,
        gameList: gameList ?? this.gameList);
  }

  Player opponentOf(User user) {
    return playerOne.user.id == user.id ? playerTwo : playerOne;
  }

  Player getUserAsPlayer(User user) {
    return playerOne.user.id == user.id ? playerOne : playerTwo;
  }

  Map<String, dynamic> toJson() => {
        "id": this.id,
        "type": this.type.toString(),
        "user": this.playerOne.toJson(),
        "opponent": this.playerTwo.toJson(),
        "userScore": this.playerOneScore,
        "opponentScore": this.playerTwoScore,
        "gameList":
            this.gameList != null ? this.gameList!.map((Game g) => g.toJson()).toList() : null
      };

  factory Match.fromJson(Map<String, dynamic> jsonObj, {MatchType? type}) {
    return Match(
      id: jsonObj['id'],
      type: type ?? getMatchTypeFromJson(jsonObj['type']),
      playerOne: Player.fromJson(jsonObj['user']),
      playerTwo: Player.fromJson(jsonObj['opponent']),
      playerOneScore: jsonObj['userScore'],
      playerTwoScore: jsonObj['opponentScore'],
      gameList: jsonObj['gameList'] != null
          ? List<Game>.from(jsonObj['gameList'].map((val) => Game.fromJson(val)))
          : [],
    );
  }

  factory Match.decodeArcanoJson(Map<String, dynamic> jsonObj) {
    return Match(
      id: jsonObj['id'],
      playerOne: Player.decodeArcanoJson(jsonObj['playerOne']),
      playerTwo: Player.decodeArcanoJson(jsonObj['playerTwo']),
      type: MatchType.online,
      playerOneScore: jsonObj['playerOneScore'],
      playerTwoScore: jsonObj['playerTwoScore'],
      gameList: List<Game>.from(jsonObj['gameList'].map((val) => Game.fromArcanoJson(val))),
    );
  }

  static MatchType getMatchTypeFromJson(String encoded) {
    if (encoded == MatchType.offline.toString()) return MatchType.offline;

    if (encoded == MatchType.tournament.toString()) return MatchType.tournament;

    if (encoded == MatchType.online.toString()) return MatchType.online;

    throw UnimplementedError();
  }

  static Map<String, dynamic> encodeArcanoJson(Match m) {
    Map<String, dynamic> arcanoMap = {};

    if (m.id != '-') arcanoMap["id"] = m.id;

    arcanoMap["playerOne"] = m.playerOne.user.toJson();
    arcanoMap["playerOneScore"] = m.playerOneScore;
    arcanoMap["playerTwo"] = m.playerTwo.user.toJson();
    arcanoMap["playerTwoScore"] = m.playerTwoScore;
    arcanoMap["gameList"] =
        m.gameList != null ? m.gameList!.map((Game g) => g.toArcanoJson()).toList() : null;
    return arcanoMap;
  }

  @override
  List<Object?> get props => [id];

  String toString() {
    return "Match($id - ($playerOneScore) - ($playerTwoScore))";
  }
}
