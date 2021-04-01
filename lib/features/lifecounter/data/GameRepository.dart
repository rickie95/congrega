import 'dart:async';

import 'package:congrega/features/lifecounter/data/PlayerRepository.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/GameState.dart';
import 'package:rxdart/rxdart.dart';
import 'package:state_persistence/state_persistence.dart';

import 'Game.dart';

class GameRepository {

  static const String GAME_KEY = 'congrega_saved_game';

  GameRepository({
    required this.playerRepository,
    // required this.storageData
  });

  final JsonFileStorage storageData = JsonFileStorage(clearDataOnLoadError: false, filename: 'data.json', initialData: {});
  final PlayerRepository playerRepository;
  final StreamController<GameStatus> _controller = new BehaviorSubject();

  Stream<GameStatus> get status async*{
    yield await _gameInProgress().then((wasInProgress) => wasInProgress ?
      GameStatus.inProgress : GameStatus.ended);
    yield* _controller.stream;
  }

  Future<bool> _gameInProgress() async {
    return !((await storageData.load().then((value) => value![GAME_KEY])) == null);
  }

  Future<void> newGame() async {
    Game game = new Game(
      team: [await playerRepository.getAuthenticatedPlayer()],
      opponents: [playerRepository.genericOpponent()],
    );
    updateGame(game);
    _controller.add(GameStatus.inProgress);
  }
  
  Future<Game> updateGame(Game game) async {
    storageData.save({GAME_KEY : game});
    return game;
  }

  Future<Game> recoverGame() async {
    return Game.fromJson(await storageData.load().then((value) => value![GAME_KEY]));
  }
  
  Future<void> endGame() async {
    storageData.save({GAME_KEY : null});
    _controller.add(GameStatus.ended);
  }

  void dispose() => _controller.close();
  
}