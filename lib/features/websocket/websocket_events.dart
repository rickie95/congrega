import 'package:equatable/equatable.dart';

class LifeCounterLiveUpdateEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class MessageReceived extends LifeCounterLiveUpdateEvent {
  final String message;

  MessageReceived({required this.message});

  @override
  List<Object?> get props => [message];
}

class SendMessage extends LifeCounterLiveUpdateEvent {
  final String message;

  SendMessage({required this.message});

  @override
  List<Object?> get props => [message];
}

class OpponentPointsUpdate extends LifeCounterLiveUpdateEvent {
  final int points;

  OpponentPointsUpdate({required this.points});

  @override
  List<Object?> get props => [points];
}
