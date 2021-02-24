import 'package:congrega/model/User.dart';
import 'package:equatable/equatable.dart';

class TournamentEvent extends Equatable{
  const TournamentEvent();

  @override
  List<Object> get props => [];
}

class EnrollingInTournament extends TournamentEvent {
  const EnrollingInTournament(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class AbandoningTournament extends TournamentEvent {
  const AbandoningTournament(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}