import 'dart:convert';

import 'package:congrega/features/lifecounter/data/Game.dart';
import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:state_persistence/state_persistence.dart';

void main(){

  test('Persist and recover a game',() async {
  PersistedStateStorage storage = new JsonFileStorage();

  Game game = Game(
    team: [Player(user: User(id: 'ididi', username: 'miki', name: 'pippo'),
        points: const {})],
    opponents: [Player.empty]
  );

  storage.save({'game' : game});

  Game gg = Game.fromJson(await storage.load().then((value) => value!['game']));

  expect(gg, equals(game));

  });

  test('Remove the game if present', () async {
    PersistedStateStorage storage = new JsonFileStorage();

    Game game = Game(
        team: [Player(user: User(id: 'ididi', username: 'miki', name: 'pippo'),
            points: const {})],
        opponents: [Player.empty]
    );

    storage.save({'game' : game});
    
    expect(!((await storage.load().then((value) => value!['game'])) == null), true);

    storage.save({'game' : null});

    expect(!((await storage.load().then((value) => value!['game'])) == null), false);
  });

}