import 'package:equatable/equatable.dart';

class Player extends Equatable {

  const Player({this.id, this.points});

  final List<PlayerPoints> points;
  final BigInt id;

  Player copyWith({BigInt id, List<PlayerPoints> list}){
    return Player(
      id: id ?? this.id,
      points: list ?? this.points
    );
  }

  @override
  List<Object> get props => [this.id, this.points];
  
}

abstract class PlayerPoints extends Equatable {
  final int _points;

  PlayerPoints(this._points);

  int get value => _points;

  @override
  List<Object> get props => [this._points];

  PlayerPoints copyWith(int points);
  bool isTheSameTypeOf(PlayerPoints points);

}

class LifePoints extends PlayerPoints {
  LifePoints(int points) : super(points);

  @override
  PlayerPoints copyWith(int points) {
    return LifePoints(points);
  }

  @override
  bool isTheSameTypeOf(PlayerPoints points) {
    return points is LifePoints;
  }
}

class VenomPoints extends PlayerPoints {
  VenomPoints(int points) : super(points);

  @override
  PlayerPoints copyWith(int points) {
    return VenomPoints(points);
  }

  @override
  bool isTheSameTypeOf(PlayerPoints points) {
    return points is VenomPoints;
  }
}

class EnergyPoints extends PlayerPoints {
  EnergyPoints(int points) : super(points);

  @override
  PlayerPoints copyWith(int points) {
    return EnergyPoints(points);
  }

  @override
  bool isTheSameTypeOf(PlayerPoints points) {
    return points is EnergyPoints;
  }

}

enum ManaColor {black, white, red, green, blue, colorless}

class ManaColorPoints extends PlayerPoints {
  final ManaColor color;

  ManaColorPoints(int points, {this.color=ManaColor.colorless}) : super(points);

  @override
  PlayerPoints copyWith(int points, {ManaColor color}) {
    return ManaColorPoints( points,
        color: color ?? this.color
    );
  }

  @override
  bool isTheSameTypeOf(PlayerPoints points) {
    return points is ManaColorPoints;
  }

  @override
  List<Object> get props => [this._points, this.color];
}