import 'dart:convert';
import 'dart:math';

import 'package:congrega/features/lifecounter/model/Game.dart';
import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:congrega/features/lifecounter/model/PlayerPoints.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Game ', () {
    test('from model to JSON and viceversa', () {
      PlayerPoints lifePoints = new LifePoints(20);
      Set<PlayerPoints> pointSet = {lifePoints};
      User user1 = User(id: '1', name: 'Mike', username: 'mike', password: 'secret');
      User user2 = User(id: '2', name: 'Brad', username: 'brad', password: 'secret');

      Player player1 = Player(user: user1, points: pointSet);
      Player player2 = Player(user: user2, points: pointSet);

      Game gg = Game(team: [player1], opponents: [player2]);

      String jsonVersion = jsonEncode(gg);

      expect(Game.fromJson(jsonDecode(jsonVersion)), equals(gg));
    });

    test('from arcano json to Game', () {
      User user = User(id: "0290b4e0-b88f-4ea7-ba50-2794970a8a57", username: "user");

      String json =
          '{"id": 0, "gamePoints": {"0290b4e0-b88f-4ea7-ba50-2794970a8a57": 20,  "7584c21b-5b6c-4820-9dde-57f6a31d31d3": 20 }, "ended": false, "winnerId": null}';
      Map<String, dynamic> decoded = jsonDecode(json);

      Game g = Game.fromArcanoJson(decoded, user);

      expect(g.team[0].id, user.id);
      expect(g.team[0].points.first, LifePoints(20));
    });

    test('from Game to Arcano JSON', () {
      PlayerPoints lifePoints = new LifePoints(20);
      Set<PlayerPoints> pointSet = {lifePoints};
      User user1 = User(id: '1', name: 'Mike', username: 'mike', password: 'secret');
      User user2 = User(id: '2', name: 'Brad', username: 'brad', password: 'secret');

      Player player1 = Player(user: user1, points: pointSet);
      Player player2 = Player(user: user2, points: pointSet);

      Game gg = Game(team: [player1], opponents: [player2]);

      Map<String, dynamic> jsonMap = gg.toArcanoJson();

      expect((jsonMap['gamePoints'] as Map<String, dynamic>).containsKey(user1.id), true);
      expect((jsonMap['gamePoints'] as Map<String, dynamic>)[user1.id], player1.points.first.value);
      expect((jsonMap['gamePoints'] as Map<String, dynamic>).containsKey(user2.id), true);
      expect((jsonMap['gamePoints'] as Map<String, dynamic>)[user2.id], player2.points.first.value);
    });
  });
}
