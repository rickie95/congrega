part of "current_deck_stats_bloc.dart";

abstract class CurrentDeckState extends Equatable {}

class CurrentDeckUnknownState extends CurrentDeckState {
  CurrentDeckUnknownState() : super();

  @override
  List<Object?> get props => [];
}

class CurrentDeckStatsState extends CurrentDeckState {
  final Deck currentDeck;
  final List<Deck> deckList;

  CurrentDeckStatsState({required this.currentDeck, required this.deckList});

  CurrentDeckStatsState copyWith({Deck? currentDeck, List<Deck>? deckList}) =>
      CurrentDeckStatsState(
          currentDeck: currentDeck ?? this.currentDeck, deckList: deckList ?? this.deckList);

  @override
  List<Object?> get props => [currentDeck, deckList];
}
