import 'package:equatable/equatable.dart';

abstract class EventFormEvent extends Equatable {
  const EventFormEvent();

  @override
  List<Object> get props => [];
}

class EventFormNameChanged extends EventFormEvent {
  const EventFormNameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class EventFormDateChanged extends EventFormEvent {
  const EventFormDateChanged(this.date);

  final DateTime date;

  @override
  List<Object> get props => [date];
}

class EventFormatChanged extends EventFormEvent {
  const EventFormatChanged(this.format);

  final String format;

  @override
  List<Object> get props => [format];
}

class EventFormLocationChanged extends EventFormEvent {
  const EventFormLocationChanged(this.location);

  final String location;
  @override
  List<Object> get props => [location];
}

class EventFormSubmitted extends EventFormEvent {
  const EventFormSubmitted();

  @override
  List<Object> get props => [];
}
