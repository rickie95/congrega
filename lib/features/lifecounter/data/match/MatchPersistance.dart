import 'dart:convert';
import 'package:congrega/features/lifecounter/model/Match.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MatchPersistence {
  
  static const String MATCH_KEY = 'congrega_match_key';
  
  Future<void> persistMatch(Match match) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    storage.setString(MATCH_KEY, jsonEncode(match));
  }
  
  Future<Match> recoverMatch() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    if(!storage.containsKey(MATCH_KEY))
      throw Error();

    String encodedMatch = storage.getString(MATCH_KEY)!;
    return Match.fromJson(jsonDecode(encodedMatch));
  }
  
  Future<bool> isInMemory() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    return storage.containsKey(MATCH_KEY);
  }
  
  Future<void> deleteSavedMatch() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    storage.remove(MATCH_KEY);
  }

}