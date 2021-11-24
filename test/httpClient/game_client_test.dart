import 'dart:convert';

import 'package:congrega/features/authentication/AuthenticationRepository.dart';
import 'package:congrega/features/lifecounter/data/game/game_client.dart';
import 'package:congrega/features/lifecounter/model/Game.dart';
import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:congrega/features/lifecounter/model/PlayerPoints.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/utils/Arcano.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'game_client_test.mocks.dart';

final String token = "TOKEN";

@GenerateMocks([http.Client, AuthenticationRepository])
void main() {
  group('GameClient', () {
    test('should create a Game through POST', () async {
      final createdGameJson =
          '{"id":1,"gamePoints":{"user-id-1":20,"user-id-2":20},"ended":false,"winnerId":null}';
      final client = MockClient();
      final authRepo = MockAuthenticationRepository();
      GameClient gc = new GameClient(httpClient: client, authRepo: authRepo);

      Game game = new Game(
        team: [
          Player(user: User(id: "user-id-1", username: "user-1"), points: {LifePoints(20)})
        ],
        opponents: [
          Player(user: User(id: "user-id-2", username: "user-2"), points: {LifePoints(20)})
        ],
      );

      when(authRepo.getToken()).thenAnswer((_) async => token);
      when(client.post(Arcano.getGamesUri(),
              headers: {'Content-Type': 'application/json', 'Authentication': 'Bearer $token'},
              body: jsonEncode(game.toArcanoJson())))
          .thenAnswer((_) async => http.Response(createdGameJson, 201));

      Game? createdGame = await gc.createGame(game);

      expect(createdGame, isNotNull);
      expect(createdGame!.id, isNotNull);
      expect(createdGame.id, equals("1"));
    });

    test('should fetch a Game through GET', () async {
      final String gameId = "1";
      final String response =
          '{"id":1,"gamePoints":{"user-id-1":20,"user-id-2":20},"ended":false,"winnerId":null}';
      final client = MockClient();
      final authRepo = MockAuthenticationRepository();
      final User user = User(id: "user-id-1", username: "user-1");

      GameClient gc = new GameClient(httpClient: client, authRepo: authRepo);

      when(client.get(Arcano.getGamesUri(gameId: gameId)))
          .thenAnswer((_) async => http.Response(response, 200));

      Game? game = await gc.getGameById(gameId, user);

      expect(game, isNotNull);
      expect(game!.id, isNotNull);
      expect(game.id, gameId);
    });
  });
}
