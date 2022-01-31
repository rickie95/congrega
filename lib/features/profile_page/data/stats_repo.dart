import 'dart:core';

import 'package:congrega/features/profile_page/data/stats_persistence.dart';
import 'package:congrega/features/profile_page/model/deck.dart';
import 'package:congrega/features/profile_page/model/stats_record.dart';

class StatsRepo {
  // tutti da salvare come json
  static List<Deck> deckList = [
    Deck.empty(),
    Deck(name: "MB Pestilence"),
    Deck(name: "UW Control")
  ];
  static List<StatsRecord> records = [
    StatsRecord(DateTime(2020, 12, 25, 16, 00), 2, 1, "LGG2", deckList[1]),
    StatsRecord(DateTime(2021, 01, 5, 12, 00), 2, 0, "DanBor", deckList[2]),
    StatsRecord(DateTime(2020, 10, 5, 11, 00), 0, 2, "MagicMike", deckList[2]),
    StatsRecord(DateTime(2021, 09, 5, 12, 00), 2, 1, "DanBor", deckList[1]),
    StatsRecord(DateTime(2021, 08, 5, 12, 00), 2, 0, "DanBor", deckList[1]),
  ];
  final StatsPersistence statsPersistence;

  StatsRepo({required this.statsPersistence});

  // Decks
  Future<List<Deck>> addDeck(Deck deck) => getDeckList().then((deckList) {
        deckList.add(deck);
        setDeckList(deckList);
        return deckList;
      });

  void removeDeck(Deck deck) => getDeckList().then((deckList) => deckList.remove(deck));

  Future<List<Deck>> getDeckList() =>
      statsPersistence.getDeckList().then((deckList) => deckList ?? [Deck.empty()]);

  void setDeckList(List<Deck> deckList) => statsPersistence.persistDeckList(deckList);

  Future<Deck> getCurrentDeck() =>
      statsPersistence.getCurrentDeck().then((deck) => deck ?? Deck.empty());

  Future<void> setCurrentDeck(Deck deck) => statsPersistence.persistCurrentDeck(deck);

  // Records
  void addRecord(StatsRecord record) => records.add(record);
  List<StatsRecord> getRecordList({int latestN = 10}) =>
      records.getRange(0, records.length < latestN ? records.length : latestN).toList();
  int recordListLength() => records.length;
  double getWinrate() => records.length != 0
      ? records.where((record) => record.userScore > record.opponentScore).length / records.length
      : 0;

  // Current Deck stats
  Future<int> getRecordLengthForCurrentDeck() => getCurrentDeck()
      .then((currentDeck) => records.where((record) => record.deck == currentDeck).length);

  Future<double> getWinrateForCurrentDeck() async {
    int currentDeckRecordLength = await getRecordLengthForCurrentDeck();
    if (currentDeckRecordLength == 0) return 0;
    int wonMatchesWithCurrentDeck = await getCurrentDeck().then((currentDeck) => records
        .where((record) => record.deck == currentDeck && record.userScore > record.opponentScore)
        .length);

    return wonMatchesWithCurrentDeck / currentDeckRecordLength;
  }
}
