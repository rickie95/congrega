import 'package:congrega/features/loginSignup/model/User.dart';
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

class WaitForRound extends TournamentEvent {
  @override
  List<Object> get props => [];
}

class RoundIsAvailable extends TournamentEvent {
  @override
  List<Object> get props => [];
}

class EndTournament extends TournamentEvent {
  @override
  List<Object> get props => [];
}
class TournamentIsScheduled extends TournamentEvent {
  @override
  List<Object> get props => [];
}