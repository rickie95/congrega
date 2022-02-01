import 'dart:convert';

import 'package:congrega/features/profile_page/model/deck.dart';
import 'package:congrega/features/profile_page/model/stats_record.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatsPersistence {
  static const String PROFILE_KEY = 'congrega_profile';

  static const String CURRENT_DECK = PROFILE_KEY + "_current_deck";
  static const String DECK_LIST = PROFILE_KEY + "_deck_list";
  static const String RECORDS = PROFILE_KEY + "_records";

  static List<StatsRecord> records = [];

  StatsPersistence() {
    if (records.isEmpty) _fetchRecords();
  }

  Future<void> persistCurrentDeck(Deck currentDeck) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    storage.setString(CURRENT_DECK, jsonEncode(currentDeck));
  }

  Future<Deck?> getCurrentDeck() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String? encodedDeck = storage.getString(CURRENT_DECK);
    if (encodedDeck == null) return null;
    return Deck.fromJson(jsonDecode(encodedDeck));
  }

  Future<void> persistDeckList(List<Deck> deckList) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    storage.setString(DECK_LIST, jsonEncode(Deck.toJsonArray(deckList)));
  }

  Future<List<Deck>?> getDeckList() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String? encodedList = storage.getString(DECK_LIST);
    if (encodedList == null) return null;
    return Deck.listFromJson(jsonDecode(encodedList));
  }

  Future<void> updateRecordList() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    storage.setString(RECORDS, jsonEncode(StatsRecord.toJsonArray(records)));
  }

  void _sortRecordList() => records.sort((a, b) => a.date.compareTo(b.date));

  List<StatsRecord> addRecord(StatsRecord record) {
    records.add(record);
    updateRecordList();
    _sortRecordList();
    return records;
  }

  void _fetchRecords() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String? encodedList = storage.getString(RECORDS);
    if (encodedList == null) return;

    records = StatsRecord.fromJsonArray(jsonDecode(encodedList));
    _sortRecordList();
  }

  List<StatsRecord> getRecords({int? latestN}) => latestN == null
      ? records
      : records.getRange(0, records.length < latestN ? records.length : latestN).toList();
}
