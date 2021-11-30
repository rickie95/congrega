import 'dart:convert';

import 'package:congrega/features/authentication/AuthenticationRepository.dart';
import 'package:congrega/features/lifecounter/model/Game.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/utils/Arcano.dart';
import 'package:http/http.dart' as http;

class GameClient {
  final http.Client httpClient;
  final AuthenticationRepository authRepo;

  GameClient({required this.httpClient, required this.authRepo});

  Future<Game?> createGame(Game game) async {
    String? token = await this.authRepo.getToken();

    http.Response response;

    try {
      response = await httpClient.post(
        Arcano.getGamesUri(),
        headers: {'Content-Type': 'application/json', 'Authentication': 'Bearer $token'},
        body: jsonEncode(game.toArcanoJson()),
      );
    } catch (e) {
      print(e.toString());
      return null;
    }

    switch (response.statusCode) {
      case 201:
        return Game.fromArcanoJson(jsonDecode(response.body));
      default:
        print(response.statusCode.toString() + " " + response.body);
    }
    return null;
  }

  Future<Game?> getGameById(String gameId) async {
    http.Response response;

    try {
      response = await httpClient.get(Arcano.getGamesUri(gameId: gameId));
    } catch (e) {
      print(e.toString());
      return null;
    }

    switch (response.statusCode) {
      case 200:
        return Game.fromArcanoJson(jsonDecode(response.body));
      case 404:
        return null;
      default:
        print(response.statusCode.toString() + " " + response.body);
    }
    return null;
  }
}
