import 'package:congrega/features/tournaments/presentation/event_form_bloc/inputs/event_name_form_input.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import 'inputs/event_format_form_input.dart';

class EventFormState extends Equatable {
  const EventFormState(
      {required this.name,
      required this.startingTime,
      required this.format,
      this.location,
      this.status = FormzStatus.pure,
      this.errorMsg = ""});

  static EventFormState initialState = EventFormState(
    name: const NameFormInput.pure(),
    format: const FormatFormInput.pure(),
    startingTime: DateTime.now(),
  );

  final NameFormInput name;
  final FormatFormInput format;
  final DateTime startingTime;
  final FormzStatus status;
  final String? location;
  final String errorMsg;

  EventFormState copyWith(
          {NameFormInput? name,
          DateTime? startingTime,
          FormatFormInput? format,
          String? location,
          FormzStatus? status,
          String? errorMsg}) =>
      EventFormState(
          name: name ?? this.name,
          startingTime: startingTime ?? this.startingTime,
          format: format ?? this.format,
          location: location ?? this.location,
          status: status ?? this.status,
          errorMsg: errorMsg ?? this.errorMsg);

  @override
  List<Object> get props => [name, format, startingTime, status, errorMsg];
}
