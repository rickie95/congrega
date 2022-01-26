import 'package:congrega/features/profile_page/data/stats_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'current_deck_stats_state.dart';
part 'current_deck_stats_event.dart';

class CurrentDeckStatsBloc extends Bloc<CurrentDeckStatsEvent, CurrentDeckState> {
  final StatsRepo statsRepo;

  CurrentDeckStatsBloc({required this.statsRepo}) : super(CurrentDeckUnknownState());

  @override
  Stream<CurrentDeckState> mapEventToState(CurrentDeckStatsEvent event) async* {
    print(this.hashCode);
    if (event is LoadCurrentDeck) {
      yield await _mapLoadCurrentDeckToState(event, state);
    } else if (event is CurrentDeckIsChanged) {
      yield await _mapDeckChangedToState(event, state as CurrentDeckStatsState);
    } else if (event is AddDeck) {
      yield await _mapAddDeckToState(event, state as CurrentDeckStatsState);
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
    statsRepo.addDeck(event.deck);
    List<Deck> deckLsit = await statsRepo.getDeckList();
    return state.copyWith(deckList: deckLsit);
  }
}
