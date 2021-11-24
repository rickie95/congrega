import 'package:congrega/features/tournaments/data/TournamentController.dart';
import 'package:congrega/features/tournaments/model/Tournament.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'TournamentEvent.dart';
import 'TournamentState.dart';

/*
    Responsible for a single tournament's management. When managing a different
    tournament, create a new bloc and set a new state.
 */

class TournamentBloc extends Bloc<TournamentEvent, TournamentState> {
  TournamentBloc({required TournamentController controller})
      : _controller = controller,
        super(const TournamentState.unknown());

  final TournamentController _controller;

  @override
  Stream<TournamentState> mapEventToState(TournamentEvent event) async* {
    if (event is EnrollPlayer) {
      yield* mapEnrollingToState(event);
    } else if (event is RetirePlayer) {
      yield mapAbandoningToState(event);
    } else if (event is RoundIsAvailable) {
      yield state.copyWith(status: TournamentStatus.IN_PROGRESS);
    } else if (event is WaitForRound) {
      yield state.copyWith(status: TournamentStatus.WAITING);
    } else if (event is EndTournament) {
      yield state.copyWith(status: TournamentStatus.ENDED);
    } else if (event is TournamentIsScheduled) {
      yield state.copyWith(status: TournamentStatus.SCHEDULED);
    } else if (event is SetTournament) {
      yield* _mapSetTournamentToState(event);
    }
  }

  Stream<TournamentState> mapEnrollingToState(EnrollPlayer event) async* {
    yield TournamentState.unknown();
    try {
      Tournament t = await _controller.enrollUserInEvent(event.user, state.tournament);
      yield state.copyWith(
        tournament: t,
        enrolled: true,
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  TournamentState mapAbandoningToState(RetirePlayer event) {
    Tournament t = _controller.removeUserFromEvent(event.user, state.tournament);
    return state.copyWith(
      tournament: t,
      enrolled: false,
    );
  }

  Stream<TournamentState> _mapSetTournamentToState(SetTournament event) async* {
    yield TournamentState.unknown();
    try {
      Tournament t = await _controller.getEventDetails(event.tournament.id);
      yield state.copyWith(tournament: t);
    } catch (exception) {
      print(exception);
    }
  }
}
