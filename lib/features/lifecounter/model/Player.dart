import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:equatable/equatable.dart';

import 'PlayerPoints.dart';

class Player extends Equatable {

  final Set<PlayerPoints> points;
  final User user;

  const Player({required this.user, required this.points});

  static const empty = Player(user: User.empty, points: {});

  String get id => this.user.id;
  String get username => this.user.username;

  static Player playerFromUser(User user) {
    return Player(
      user: user,
      points: new Set<PlayerPoints>()..add(LifePoints(20))
    );
  }

  Player copyWith({User? user, Set<PlayerPoints>? list}){
    return Player(
      user: user ?? this.user,
      points: list ?? this.points,
    );
  }

  bool hasPointsOfType(Type pointsToCheck){
    for(PlayerPoints p in points)
      if(p.isTheSameTypeOf(pointsToCheck))
        return true;

    return false;
  }

  factory Player.fromJson(Map<String, dynamic> obj) {
    return Player(
      user: User.fromJson(obj['user']),
      points: Set<PlayerPoints>.from( obj['playerPoints'].map((val) => PlayerPoints.fromJson(val)))
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'user' : user.toJson(),
      'playerPoints' : this.points.map((PlayerPoints p) => p.toJson()).toList(),
    };
  }

  @override
  List<Object> get props => [this.user, this.points];
  
}