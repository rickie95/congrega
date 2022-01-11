import 'package:congrega/features/lifecounter/model/Game.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/features/users/UserRepository.dart';
import 'package:congrega/features/websocket/websocket_client.dart';
import 'package:congrega/utils/Arcano.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logger/logger.dart';

class GameLiveManager {
  late WebSocketClient wsClient;
  late User authenticatedUser;

  final Logger logger = Logger();

  GameLiveManager() {
    this.wsClient = WebSocketClient(wsUri: Arcano.getWSGameUri('', ''));
  }

  void setupWs(Game game) async {
    authenticatedUser = await KiwiContainer().resolve<UserRepository>().getUser();
    if (game.id != null) {
      this.wsClient.setUri(Arcano.getWSGameUri(game.id!, authenticatedUser.id));
      logger.i("Setting uri as " + Arcano.getWSGameUri(game.id!, authenticatedUser.id).toString());
    }
  }

  void setOnLifePointsUpdateCallback(Function(int) onLifePointsUpdate) {
    wsClient.setOnMessage((points) {
      logger.i("Message arrived: " + points.toString());
      int? pointsAmount = int.tryParse(points);
      if (pointsAmount != null) onLifePointsUpdate(pointsAmount);
    });
  }

  void updateLifePoints(int points) {
    logger.d("Updating life points " + points.toString());
    wsClient.sendMessage(points.toString());
  }
}
