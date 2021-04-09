import 'dart:async';

import 'package:congrega/features/lifecounter/data/PlayerRepository.dart';
import 'package:congrega/features/lifecounter/data/game/GamePersistance.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/LifeCounterState.dart';
import 'package:rxdart/rxdart.dart';

import '../../model/Game.dart';

class GameRepository {

  static const String GAME_KEY = 'congrega_saved_game';

  GameRepository({
    required this.playerRepository,
    required this.persistence
  });

  final GamePersistence persistence;
  final PlayerRepository playerRepository;
  final StreamController<GameStatus> _controller = new BehaviorSubject();

  Stream<GameStatus> get status async*{
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
  
  Future<Game> _recoverGame() => persistence.recoverGame();

  Future<Game> _newOfflineGame() async {
    Game game = new Game(
      team: [await playerRepository.getAuthenticatedPlayer()],
      opponents: [playerRepository.genericOpponent()],
    );
    updateGame(game);
    return game;
  }
  
  Future<void> updateGame(Game game) async {
    return persistence.persistGame(game);
  }
  
  Future<void> endGame() async {
    persistence.deleteSavedGame()
        .then((_) => _controller.add(GameStatus.ended));
  }

  void dispose() => _controller.close();
  
}