import 'dart:convert';

import 'package:congrega/features/lifecounter/model/Game.dart';
import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:congrega/features/lifecounter/model/PlayerPoints.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  
  group('Game ', (){
    
    test('from model to JSON and viceversa', (){
      PlayerPoints lifePoints = new LifePoints(20);
      Set<PlayerPoints> pointSet = {lifePoints};
      User user1 = User(id: '1', name: 'Mike', username: 'mike', password: 'secret');
      User user2 = User(id: '2', name: 'Brad', username: 'brad', password: 'secret');

      Player player1 = Player(user: user1, points: pointSet);
      Player player2 = Player(user: user2, points: pointSet);
      
      Game gg = Game(
        team: [player1],
        opponents: [player2]
      );

      String jsonVersion = jsonEncode(gg);

      expect(Game.fromJson(jsonDecode(jsonVersion)), equals(gg));
    });
    
  });
  
}