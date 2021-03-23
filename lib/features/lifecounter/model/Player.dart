import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

abstract class PlayerPoints extends Equatable {

  static final List<Type> playerCountersTypes = [ VenomPoints,
    EnergyPoints, ManaColorPoints ];

  static PlayerPoints getInstanceOf(Type playerPointsType,
      {ManaColor color = ManaColor.colorless}) {
    if (playerPointsType == VenomPoints){
      return VenomPoints(0);
    } else if (playerPointsType == EnergyPoints) {
      return EnergyPoints(0);
    } else if (playerPointsType == ManaColorPoints) {
      return ManaColorPoints(0, color: color);
    }
    throw ErrorDescription("There's no $playerPointsType of type ${playerPointsType.toString}");
  }

  final int _points;

  PlayerPoints(this._points);

  int get value => _points;

  @override
  List<Object> get props => [this._points];

  PlayerPoints copyWith(int points);
  bool isTheSameTypeOf(Type points);

}

class LifePoints extends PlayerPoints {
  LifePoints(int points) : super(points);

  @override
  PlayerPoints copyWith(int points) {
    return LifePoints(points);
  }

  @override
  bool isTheSameTypeOf(Type points) {
    return points == LifePoints;
  }
}

class VenomPoints extends PlayerPoints {
  VenomPoints(int points) : super(points);

  @override
  PlayerPoints copyWith(int points) {
    return VenomPoints(points);
  }

  @override
  bool isTheSameTypeOf(Type points) {
    return points == VenomPoints;
  }
}

class EnergyPoints extends PlayerPoints {
  EnergyPoints(int points) : super(points);

  @override
  PlayerPoints copyWith(int points) {
    return EnergyPoints(points);
  }

  @override
  bool isTheSameTypeOf(Type points) {
    return points == EnergyPoints;
  }

}

enum ManaColor {black, white, red, green, blue, colorless}

class ManaColorPoints extends PlayerPoints {
  final ManaColor color;

  ManaColorPoints(int points, {this.color=ManaColor.colorless}) : super(points);

  @override
  PlayerPoints copyWith(int points, {ManaColor? color}) {
    return ManaColorPoints( points,
        color: color ?? this.color
    );
  }

  @override
  bool isTheSameTypeOf(Type points) {
    return points == ManaColorPoints;
  }

  @override
  List<Object> get props => [this._points, this.color];
}

class Player extends Equatable {

  const Player({required this.id, required this.points, required this.username});

  static Player playerFromUser(User user, PlayerPoints points) {
    return Player(
      id: user.id,
      username: user.username,
      points: new Set<PlayerPoints>()..add(LifePoints(20))
    );
  }

  final Set<PlayerPoints> points;
  final String id;
  final String username;

  Player copyWith({String? id, Set<PlayerPoints>? list, String? username}){
    return Player(
      id: id ?? this.id,
      points: list ?? this.points,
      username: username ?? this.username
    );
  }

  bool hasPointsOfType(Type pointsToCheck){
    for(PlayerPoints p in points)
      if(p.isTheSameTypeOf(pointsToCheck))
        return true;

    return false;
  }

  @override
  List<Object> get props => [this.id, this.points, this.username];
  
}