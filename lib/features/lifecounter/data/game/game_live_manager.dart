import 'package:congrega/features/lifecounter/model/Game.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/features/users/UserRepository.dart';
import 'package:congrega/features/websocket/websocket_client.dart';
import 'package:congrega/utils/Arcano.dart';
import 'package:kiwi/kiwi.dart';

class GameLiveManager {
  late WebSocketClient wsClient;
  late User authenticatedUser;

  GameLiveManager() {
    this.wsClient = WebSocketClient(wsUri: Arcano.getWSGameUri('', ''));
  }

  void setupWs(Game game) async {
    authenticatedUser = await KiwiContainer().resolve<UserRepository>().getUser();
    this.wsClient.setUri(Arcano.getWSGameUri(game.id!, authenticatedUser.id));
  }

  void setOnLifePointsUpdateCallback(Function(int) onLifePointsUpdate) {
    wsClient.setOnMessage((points) {
      print("[${authenticatedUser.username} | GAME_LIVE_MNG ] => " + points);
      int? pointsAmount = int.tryParse(points);
      if (pointsAmount != null) onLifePointsUpdate(pointsAmount);
    });
  }

  void updateLifePoints(int points) => wsClient.sendMessage(points.toString());
}
