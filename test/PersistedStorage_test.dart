import 'dart:convert';

import 'package:congrega/features/lifecounter/model/Game.dart';
import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){



  test('Persist and recover a game',() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Game game = Game(
        team: [Player(user: User(id: 'ididi', username: 'miki', name: 'pippo'),
            points: const {})],
        opponents: [Player.empty]
    );

    prefs.setString('game', jsonEncode(game));

    expect(Game.fromJson(jsonDecode(prefs.getString('game')!)).team[0].id, equals("ididi"));
    prefs.clear();
  });

  test('Remove the game if present', () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Game game = Game(
        team: [Player(user: User(id: 'ididi', username: 'miki', name: 'pippo'),
            points: const {})],
        opponents: [Player.empty]
    );

    prefs.setString('game', jsonEncode(game));
    
    expect(prefs.containsKey('game'), true);

    prefs.remove('game');

    expect(prefs.containsKey('game'), false);
    prefs.clear();
  });

  test('Save something and save another thing, check if #1 is still present', () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Game game = Game(
        team: [Player(user: User(id: 'ididi', username: 'miki', name: 'pippo'),
            points: const {})],
        opponents: [Player.empty]
    );

    prefs.setString('game', jsonEncode(game));

    prefs.setInt('candy', 23);

    expect(Game.fromJson(jsonDecode(prefs.getString('game')!)).team[0].id, equals("ididi"));
    prefs.clear();
  });

}