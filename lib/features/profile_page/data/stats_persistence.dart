import 'dart:convert';

import 'package:congrega/features/profile_page/model/deck.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatsPersistence {
  static const String PROFILE_KEY = 'congrega_profile';

  static const String CURRENT_DECK = PROFILE_KEY + "_current_deck";
  static const String DECK_LIST = PROFILE_KEY + "_deck_list";

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
}
