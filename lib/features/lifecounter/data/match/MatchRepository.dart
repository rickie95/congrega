import 'package:congrega/features/lifecounter/data/match/MatchPersistance.dart';
import 'package:congrega/features/lifecounter/model/Match.dart';
import 'package:flutter/material.dart';

class MatchRepository {
  
  static const String MATCH_KEY = "congrega_match_key";

  final MatchPersistence persistence;

  MatchRepository({required this.persistence});


  Future<Match> newOfflineMatch(Match newMatch) async {
    persistMatch(newMatch);
    return newMatch;
}

  Future<void> updateMatch(Match tobeUpdated) async {
    debugPrint("Updated $tobeUpdated");
    syncMatch(tobeUpdated);
    persistMatch(tobeUpdated);
  }

  Future<void> endMatch(Match toBeEnded) async {
    debugPrint("Leaving $toBeEnded");
    syncMatch(toBeEnded);
    removeSavedMatch();
  }

  Future<Match> getCurrentMatch() {
    return persistence.recoverMatch();
  }

  Future<bool> checkPreviousMatch() async {
    return persistence.isInMemory();
  }

  Future<void> persistMatch(Match match){
    return persistence.persistMatch(match);
  }

  Future<void> removeSavedMatch() async {
    return persistence.deleteSavedMatch();
  }

  void syncMatch(Match m){
    if(m.type == MatchType.tournament)
      debugPrint("Sent to server");
  }

}