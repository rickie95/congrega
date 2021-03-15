import 'package:congrega/features/tournaments/presentation/bloc/TournamentController.dart';
import 'package:congrega/features/tournaments/model/Tournament.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'TournamentEvent.dart';
import 'TournamentState.dart';

/*
    Responsible for a single tournament's management. When managing a different
    tournament, create a new bloc and set a new state.
 */

class TournamentBloc extends Bloc<TournamentEvent, TournamentState> {
  TournamentBloc({
    required TournamentState initialState,
    required TournamentController controller}) :
        _controller = controller,
        super(initialState);
  
  final TournamentController _controller;

  @override
  Stream<TournamentState> mapEventToState(TournamentEvent event) async* {
    if(event is EnrollingInTournament){
      yield mapEnrollingToState(event);
    } else if(event is AbandoningTournament){
      yield mapAbandoningToState(event);
    } else if(event is TournamentIsInProgress){
      yield state.copyWith(status: TournamentStatus.inProgress);
    }else if(event is TournamentIsWaiting){
      yield state.copyWith(status: TournamentStatus.waiting);
    }else if(event is TournamentEnds){
      yield state.copyWith(status: TournamentStatus.ended);
    }else if(event is TournamentIsScheduled){
      yield state.copyWith(status: TournamentStatus.scheduled);
    }
  }

  TournamentState mapEnrollingToState(EnrollingInTournament event) {
    Tournament t = _controller.enrollUserInEvent(event.user, state.tournament);
    return state.copyWith(
      tournament: t,
      enrolled: true,
    );
  }

  TournamentState mapAbandoningToState(AbandoningTournament event) {
    Tournament t = _controller.removeUserFromEvent(event.user, state.tournament);
    return state.copyWith(
        tournament: t,
        enrolled: false,
    );
  }
  
}