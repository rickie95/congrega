
import 'package:congrega/features/tournaments/model/Tournament.dart';
import 'package:equatable/equatable.dart';

class TournamentState extends Equatable {

  const TournamentState({
    required this.tournament,
    required this.enrolled,
    required this.round,
    required this.status,
  });

  final Tournament tournament;
  final bool enrolled;
  final int round;
  final TournamentStatus status;

  TournamentState copyWith({Tournament? tournament, bool? enrolled, int? round, TournamentStatus? status}){
    return TournamentState(
      tournament: tournament ?? this.tournament,
      enrolled: enrolled ?? this.enrolled,
      round: round ?? this.round,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [tournament, enrolled, round, status];

}