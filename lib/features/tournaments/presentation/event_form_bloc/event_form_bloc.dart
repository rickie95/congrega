import 'package:congrega/features/tournaments/data/TournamentController.dart';
import 'package:congrega/features/tournaments/model/Tournament.dart';
import 'package:congrega/features/tournaments/presentation/event_form_bloc/inputs/event_format_form_input.dart';
import 'package:congrega/features/tournaments/presentation/event_form_bloc/inputs/event_name_form_input.dart';
import 'package:congrega/features/users/UserRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'event_form_event.dart';
import 'event_form_state.dart';

class EventFormBloc extends Bloc<EventFormEvent, EventFormState> {
  EventFormBloc({required this.tournamentController, required this.userRepository})
      : super(EventFormState.initialState);

  final TournamentController tournamentController;
  final UserRepository userRepository;

  @override
  Stream<EventFormState> mapEventToState(EventFormEvent event) async* {
    if (event is EventFormNameChanged) {
      yield _mapNameChangedToState(event, state);
    } else if (event is EventFormatChanged) {
      yield _mapFormatChangedToState(event, state);
    } else if (event is EventFormDateChanged) {
      yield _mapDateChangedToState(event, state);
    } else if (event is EventFormLocationChanged) {
      yield _mapLocationChangedToState(event, state);
    } else if (event is EventFormSubmitted) {
      yield* _mapEventFormSubmittedToState(event, state);
    }
  }

  EventFormState _mapDateChangedToState(EventFormDateChanged event, EventFormState state) {
    return state.copyWith(startingTime: event.date);
  }

  EventFormState _mapFormatChangedToState(EventFormatChanged event, EventFormState state) {
    final FormatFormInput updatedFormat = FormatFormInput.dirty(event.format);
    return state.copyWith(
        format: updatedFormat, status: Formz.validate([updatedFormat, state.name]));
  }

  EventFormState _mapNameChangedToState(EventFormNameChanged event, EventFormState state) {
    final NameFormInput updatedName = NameFormInput.dirty(event.name);
    return state.copyWith(name: updatedName, status: Formz.validate([updatedName, state.format]));
  }

  Stream<EventFormState> _mapEventFormSubmittedToState(
      EventFormSubmitted event, EventFormState state) async* {
    if (state.status.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        Tournament t = new Tournament(
            id: '',
            name: state.name.value,
            playerList: {},
            adminList: {await userRepository.getUser()},
            judgeList: {},
            type: state.format.value,
            startingTime: state.startingTime,
            status: TournamentStatus.SCHEDULED,
            round: 0);
        await tournamentController.createNewEvent(t);
        yield state.copyWith(status: FormzStatus.submissionSuccess);
      } on Exception catch (ex) {
        yield state.copyWith(status: FormzStatus.submissionFailure, errorMsg: ex.toString());
      }
    }
  }

  EventFormState _mapLocationChangedToState(EventFormLocationChanged event, EventFormState state) {
    return state.copyWith(location: event.location);
  }
}
