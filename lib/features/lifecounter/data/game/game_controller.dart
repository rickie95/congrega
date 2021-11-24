import 'package:congrega/features/lifecounter/data/game/GameRepository.dart';
import 'package:congrega/features/lifecounter/model/Game.dart';

class GameController {
  final GameRepository gameRepository;

  GameController({required this.gameRepository});

  Future<Game?> createOnlineGame(Game game) {
    return gameRepository.newOnlineGame(game);
  }
}
