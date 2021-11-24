import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/features/tournaments/model/Tournament.dart';
import 'package:equatable/equatable.dart';

class TournamentEvent extends Equatable{
  const TournamentEvent();

  @override
  List<Object> get props => [];
}

class EnrollPlayer extends TournamentEvent {
  const EnrollPlayer(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class RetirePlayer extends TournamentEvent {
  const RetirePlayer(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class SetTournament extends TournamentEvent {
  SetTournament(this.tournament);

  final Tournament tournament;

  @override
  List<Object> get props => [tournament];
}

class WaitForRound extends TournamentEvent {
  const WaitForRound();
  @override
  List<Object> get props => [];
}

class RoundIsAvailable extends TournamentEvent {
  const RoundIsAvailable();

  @override
  List<Object> get props => [];
}

class EndTournament extends TournamentEvent {
  const EndTournament();
  @override
  List<Object> get props => [];
}
class TournamentIsScheduled extends TournamentEvent {
  const TournamentIsScheduled();

  @override
  List<Object> get props => [];
}