import 'dart:convert';

import 'package:congrega/features/lifecounter/model/Game.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GamePersistence {
  static const String GAME_KEY = 'congrega_saved_game';

  Future<void> persistGame(Game game) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    storage.setString(GAME_KEY, jsonEncode(game.toJson()));
  }

  Future<Game> recoverGame() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    if (!storage.containsKey(GAME_KEY)) throw Error();

    String encodedGame = storage.getString(GAME_KEY)!;
    return Game.fromJson(jsonDecode(encodedGame));
  }

  Future<bool> isInMemory() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    return storage.containsKey(GAME_KEY);
  }

  Future<void> deleteSavedGame() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    storage.remove(GAME_KEY);
  }
}
