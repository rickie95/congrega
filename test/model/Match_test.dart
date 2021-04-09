import 'dart:convert';

import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:congrega/features/lifecounter/model/Match.dart';

void main(){
  
  test('Match to and from json', (){

    Match match = Match(
      id: 'match-001',
      user: Player.playerFromUser(User(id: 'user-001', username: 'mike', name: 'Mike', password: 'secret1')),
      opponent: Player.playerFromUser(User(id: 'user-002', username: 'brad', name: 'Brad', password: 'secret2')),
      opponentScore: 1,
      userScore: 2,
      type: MatchType.offline
    );

    String jsonBody = jsonEncode(match);

    Match recoveredMatch = Match.fromJson(jsonDecode(jsonBody));

    expect(recoveredMatch.id, equals(match.id));
    expect(recoveredMatch.type, equals(match.type));
    expect(recoveredMatch.user, equals(match.user));

  });
  
}