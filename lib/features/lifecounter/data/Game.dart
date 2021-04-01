import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:equatable/equatable.dart';

class Game extends Equatable {
  
  const Game({required this.team, required this.opponents});
  
  final List<Player> team;
  final List<Player> opponents;

  @override
  List<Object?> get props => [team, opponents];

  Map<String, dynamic> toJson() => {
    "team": this.team.map((Player p) => p.toJson()).toList(),
    "opponents": this.opponents.map((Player p) => p.toJson()).toList(),
  };

  factory Game.fromJson(Map<String, dynamic> obj) {
    return Game(
      team: List<Player>.from(obj['team'].map((val) => Player.fromJson(val))),
      opponents: List<Player>.from(obj['opponents'].map((val) => Player.fromJson(val))),
    );
  }

}