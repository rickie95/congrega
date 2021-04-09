import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:equatable/equatable.dart';

class TournamentEvent extends Equatable {
  
  const TournamentEvent();
  
  @override
  List<Object?> get props => [];
}

class PlayerLoseMatch extends TournamentEvent {
  const PlayerLoseMatch(this.player);
  
  final Player player;

  @override
  List<Object?> get props => [player];
}