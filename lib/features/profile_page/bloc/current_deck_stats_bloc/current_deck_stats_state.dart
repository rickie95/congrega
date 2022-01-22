part of "current_deck_stats_bloc.dart";

abstract class CurrentDeckState extends Equatable {}

class CurrentDeckUnknownState extends CurrentDeckState {
  CurrentDeckUnknownState() : super();

  @override
  List<Object?> get props => [];
}

class CurrentDeckStatsState extends CurrentDeckState {
  final Deck currentDeck;

  CurrentDeckStatsState({required this.currentDeck});

  CurrentDeckStatsState copyWith({Deck? currentDeck}) =>
      CurrentDeckStatsState(currentDeck: currentDeck ?? this.currentDeck);

  @override
  List<Object?> get props => [currentDeck];
}
