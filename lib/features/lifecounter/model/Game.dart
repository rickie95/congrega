import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:congrega/features/lifecounter/model/PlayerPoints.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:equatable/equatable.dart';

class Game extends Equatable {
  static const empty = const Game(team: [], opponents: []);

  const Game({required this.team, required this.opponents, this.id});

  final String? id;
  final List<Player> team;
  final List<Player> opponents;

  @override
  List<Object?> get props => [team, opponents];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      "team": this.team.map((Player p) => p.toJson()).toList(),
      "opponents": this.opponents.map((Player p) => p.toJson()).toList(),
    };
    if (this.id != null) json["id"] = id;

    return json;
  }

  Map<String, dynamic> toArcanoJson() {
    Map<String, dynamic> json = {
      "gamePoints": {
        "${this.team[0].id}":
            this.team[0].points.where((element) => element is LifePoints).first.value,
        "${this.opponents[0].id}":
            this.opponents[0].points.where((element) => element is LifePoints).first.value,
      }
    };
    if (id != null) {
      json["id"] = id;
    }
    return json;
  }

  factory Game.fromArcanoJson(Map<String, dynamic> obj) {
    Map<String, dynamic> gamePoints = obj["gamePoints"];
    List<Player> pp = [];

    gamePoints.forEach(
      (String id, dynamic lifePoints) => pp.add(
        Player(
          user: User(id: id, username: ''),
          points: Set<PlayerPoints>()
            ..add(
              LifePoints(lifePoints),
            ),
        ),
      ),
    );

    return Game(
      id: obj["id"].toString(),
      team: [pp[0]],
      opponents: [pp[1]],
    );
  }

  factory Game.fromJson(Map<String, dynamic> obj) {
    return Game(
      id: obj.containsKey("id") ? obj["key"] : null,
      team: List<Player>.from(obj['team'].map((val) => Player.fromJson(val))),
      opponents: List<Player>.from(obj['opponents'].map((val) => Player.fromJson(val))),
    );
  }
}
