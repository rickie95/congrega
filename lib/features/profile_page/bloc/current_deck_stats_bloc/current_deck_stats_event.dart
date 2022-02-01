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

class AddDeck extends CurrentDeckStatsEvent {
  final Deck deck;

  const AddDeck({required this.deck});

  @override
  List<Object?> get props => [deck];
}

class UpdateDeck extends CurrentDeckStatsEvent {
  final Deck deck;

  const UpdateDeck({required this.deck});

  @override
  List<Object?> get props => [deck];
}

class RemoveDeck extends CurrentDeckStatsEvent {
  final Deck deck;

  const RemoveDeck({required this.deck});

  @override
  List<Object?> get props => [deck];
}
