import 'dart:convert';

import 'package:congrega/features/profile_page/data/stats_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatsPersistence {
  static const String PROFILE_KEY = 'congrega_profile';

  static const String CURRENT_DECK = PROFILE_KEY + "_current_deck";

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
}
