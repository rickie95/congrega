part of 'current_deck_stats_bloc.dart';

abstract class CurrentDeckStatsEvent extends Equatable {
  const CurrentDeckStatsEvent();
}

class CurrentDeckIsChanged extends CurrentDeckStatsEvent {
  final Deck currentDeck;
  const CurrentDeckIsChanged({required this.currentDeck});
  @override
  List<Object?> get props => [currentDeck];
}

class LoadCurrentDeck extends CurrentDeckStatsEvent {
  @override
  List<Object?> get props => [];
}
