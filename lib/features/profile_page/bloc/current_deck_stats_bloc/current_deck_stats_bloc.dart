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
    if (event is LoadCurrentDeck) {
      yield await _mapLoadCurrentDeckToState(event, state);
    } else if (event is CurrentDeckIsChanged) {
      yield _mapDeckChangedToState(event, state);
    }
  }

  CurrentDeckStatsState _mapDeckChangedToState(CurrentDeckIsChanged event, CurrentDeckState state) {
    statsRepo.setCurrentDeck(event.currentDeck);
    if (state is CurrentDeckUnknownState)
      return CurrentDeckStatsState(currentDeck: event.currentDeck);

    return (state as CurrentDeckStatsState).copyWith(currentDeck: event.currentDeck);
  }

  Future<CurrentDeckStatsState> _mapLoadCurrentDeckToState(
      LoadCurrentDeck event, CurrentDeckState state) async {
    return CurrentDeckStatsState(currentDeck: await statsRepo.getCurrentDeck());
  }
}
