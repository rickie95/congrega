import 'package:congrega/tournament/bloc/TournamentEvent.dart';
import 'package:congrega/tournament/bloc/TournamentState.dart';
import 'package:congrega/tournament/controller/TournamentController.dart';
import 'package:congrega/tournament/model/Tournament.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/*
    Responsible for a single tournament's management. When managing a different
    tournament, create a new bloc and set a new state.
 */

class TournamentBloc extends Bloc<TournamentEvent, TournamentState> {
  TournamentBloc({TournamentState initialState = const TournamentState(),
    TournamentController controller}) :
        assert(controller != null),
        _controller = controller,
        super(initialState);
  
  final TournamentController _controller;

  @override
  Stream<TournamentState> mapEventToState(TournamentEvent event) async* {
    if(event is EnrollingInTournament){
      yield mapEnrollingToState(event);
    } else if(event is AbandoningTournament){
      yield mapAbandoningToState(event);
    }
  }

  TournamentState mapEnrollingToState(EnrollingInTournament event) {
    Tournament t = _controller.enrollUserInEvent(event.user, state.tournament);
    return TournamentState(
      tournament: t,
      enrolled: true,
    );
  }

  TournamentState mapAbandoningToState(AbandoningTournament event) {
    Tournament t = _controller.removeUserFromEvent(event.user, state.tournament);
    return TournamentState(
        tournament: t,
        enrolled: false,
    );
  }
  
}