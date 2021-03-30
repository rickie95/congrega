import 'dart:convert';

import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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

  Map<String, dynamic> toJson();

  factory PlayerPoints.fromJson(Map<String, dynamic> obj) {
    if(obj['type'] == 'LifePoints')
      return LifePoints.fromJson(obj);

    if(obj['type'] == 'VenomPoints')
      return VenomPoints.fromJson(obj);

    if(obj['type'] == 'EnergyPoints')
      return EnergyPoints.fromJson(obj);

    if(obj['type'] == 'ManaColorPoints')
      return ManaColorPoints.fromJson(obj);

    throw Exception('PlayerPoint type unknown');
  }

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

  @override
  Map<String, dynamic> toJson() => {
    'type' : 'LifePoints',
    'points' : this._points
  };

  @override
  factory LifePoints.fromJson(Map<String, dynamic> obj) {
    return LifePoints(obj['points']);
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

  @override
  Map<String, dynamic> toJson() => {
    'type' : 'VenomPoints',
    'points' : this._points
  };

  @override
  factory VenomPoints.fromJson(Map<String, dynamic> obj) {
    return VenomPoints(obj['points']);
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

  @override
  Map<String, dynamic> toJson() => {
    'type' : 'EnergyPoints',
    'points' : this._points
  };

  @override
  factory EnergyPoints.fromJson(Map<String, dynamic> obj) {
    return EnergyPoints(obj['points']);
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

  @override
  Map<String, dynamic> toJson() => {
    'type' : 'ManaPoints',
    'points' : this._points,
    'color' : this.color
  };

  @override
  factory ManaColorPoints.fromJson(Map<String, dynamic> obj) {
    return ManaColorPoints(obj['points'], color: obj['color']);
  }
}

class Player extends Equatable {

  final Set<PlayerPoints> points;
  final User user;

  const Player({required this.user, required this.points});

  static const empty = Player(user: User.empty, points: {});

  get id => this.user.id;
  get username => this.user.username;

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