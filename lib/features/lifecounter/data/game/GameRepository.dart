import 'dart:async';

import 'package:congrega/features/lifecounter/data/PlayerRepository.dart';
import 'package:congrega/features/lifecounter/data/game/GamePersistance.dart';
import 'package:congrega/features/lifecounter/data/game/game_client.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/LifeCounterState.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:rxdart/rxdart.dart';

import '../../model/Game.dart';

class GameRepository {
  static const String GAME_KEY = 'congrega_saved_game';

  GameRepository(
      {required this.playerRepository, required this.persistence, required this.gameClient});

  final GamePersistence persistence;
  final PlayerRepository playerRepository;
  final GameClient gameClient;
  final StreamController<GameStatus> _controller = new BehaviorSubject();

  Stream<GameStatus> get status async* {
    yield await _gameInProgress().then((_) => GameStatus.inProgress);
    yield* _controller.stream;
  }

  Future<Game> getCurrentGame() async {
    return _gameInProgress()
        .then((bool isInProgress) => isInProgress ? _recoverGame() : _newOfflineGame());
  }

  Future<bool> _gameInProgress() async {
    return persistence.isInMemory();
  }

  Future<Game> newGame(Game g) => updateGame(g).then((_) => g);

  Future<Game?> newOnlineGame(Game g) {
    return gameClient.createGame(g).then((createdGame) => updateGame(createdGame));
  }

  Future<Game?> fetchOnlineGame(String id, User user) {
    return gameClient.getGameById(id);
  }

  Future<Game> _recoverGame() => persistence.recoverGame();

  Future<Game> _newOfflineGame() async {
    Game game = new Game(
      team: [await playerRepository.getAuthenticatedPlayer()],
      opponents: [playerRepository.genericOpponent()],
    );
    updateGame(game);
    return game;
  }

  Future<Game?> updateGame(Game? game) async {
    if (game != null)
      return persistence.persistGame(game).then((_) {
        _controller.add(GameStatus.inProgress);
        return game;
      });
    print("game is null");
    return null;
  }

  Future<void> endGame() async {
    persistence.deleteSavedGame().then((_) => _controller.add(GameStatus.ended));
  }

  void dispose() => _controller.close();
}
