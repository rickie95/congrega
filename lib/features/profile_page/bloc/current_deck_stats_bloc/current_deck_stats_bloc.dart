import 'package:congrega/features/profile_page/data/stats_repo.dart';
import 'package:congrega/features/profile_page/model/deck.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'current_deck_stats_state.dart';
part 'current_deck_stats_event.dart';

class CurrentDeckStatsBloc extends Bloc<CurrentDeckStatsEvent, CurrentDeckState> {
  final StatsRepo statsRepo;

  CurrentDeckStatsBloc({required this.statsRepo}) : super(CurrentDeckUnknownState());

  @override
  Stream<CurrentDeckState> mapEventToState(CurrentDeckStatsEvent event) async* {
    if (event is LoadCurrentDeck) {
      yield await _mapLoadCurrentDeckToState(event, state);
    } else if (event is CurrentDeckIsChanged) {
      yield await _mapDeckChangedToState(event, state as CurrentDeckStatsState);
    } else if (event is AddDeck) {
      yield await _mapAddDeckToState(event, state as CurrentDeckStatsState);
    } else if (event is UpdateDeck) {
      yield await _mapUpdateDeckToState(event, state as CurrentDeckStatsState);
    } else if (event is RemoveDeck) {
      yield await _mapRemoveDeckToState(event, state as CurrentDeckStatsState);
    }
  }

  Future<CurrentDeckStatsState> _mapLoadCurrentDeckToState(
      LoadCurrentDeck event, CurrentDeckState state) async {
    return CurrentDeckStatsState(
        currentDeck: await statsRepo.getCurrentDeck(), deckList: await statsRepo.getDeckList());
  }

  Future<CurrentDeckStatsState> _mapDeckChangedToState(
      CurrentDeckIsChanged event, CurrentDeckStatsState state) async {
    statsRepo.setCurrentDeck(event.currentDeck);
    return state.copyWith(currentDeck: event.currentDeck);
  }

  Future<CurrentDeckStatsState> _mapAddDeckToState(
      AddDeck event, CurrentDeckStatsState state) async {
    List<Deck> deckList = await statsRepo.addDeck(event.deck);
    return state.copyWith(deckList: deckList);
  }

  Future<CurrentDeckStatsState> _mapUpdateDeckToState(
      UpdateDeck event, CurrentDeckStatsState state) async {
    List<Deck> deckList = await statsRepo.updateDeck(event.deck);
    return state.copyWith(deckList: deckList);
  }

  Future<CurrentDeckStatsState> _mapRemoveDeckToState(
      RemoveDeck event, CurrentDeckStatsState state) async {
    List<Deck> deckList = await statsRepo.removeDeck(event.deck);
    return state.copyWith(deckList: deckList);
  }
}
