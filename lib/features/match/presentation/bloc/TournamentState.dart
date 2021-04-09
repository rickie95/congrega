import 'package:congrega/features/tournaments/model/Tournament.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TournamentState extends Equatable {
  const TournamentState();
}

class InitialTournamentState extends TournamentState {
  const InitialTournamentState();

  @override
  List<Object?> get props => [];
}

class TournamentInProgressState extends TournamentState {
  const TournamentInProgressState({required this.tournament});
  
  final Tournament tournament;

  @override
  List<Object?> get props => [tournament];
  
}