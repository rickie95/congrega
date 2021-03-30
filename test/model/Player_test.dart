import 'dart:convert';

import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){

  group('From ', (){

    test('Player to JSON and viceversa', (){
      PlayerPoints lifePoints = new LifePoints(20);
      Set<PlayerPoints> pointSet = {lifePoints};
      User user = User(id: '1', name: 'Mike', username: 'mike', password: 'secret');
      
      Player player = Player(user: user, points: pointSet);
      String jsonVersion = jsonEncode(player);

      Player decodedPlayer = Player.fromJson(jsonDecode(jsonVersion));

      expect(decodedPlayer, equals(player));

    });

  });

}