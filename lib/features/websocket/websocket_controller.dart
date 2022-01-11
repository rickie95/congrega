import 'package:congrega/features/websocket/websocket_bloc.dart';
import 'package:congrega/features/websocket/websocket_client.dart';
import 'package:congrega/features/websocket/websocket_events.dart';
import 'package:congrega/utils/Arcano.dart';

class LiveMatchController {
  late WebSocketClient wsClient;
  late LifeCounterLiveUpdateBloc wsBloc;

  LiveMatchController({required this.wsBloc}) {
    this.wsClient = new WebSocketClient(
        wsUri: Arcano.getWSGameUri("0", "6e805ecb-3591-4772-bf4b-7fe462f8421f"));
  }

  void setOnMessageCallback(Function(dynamic) onMessage) {
    wsClient.setOnMessage((message) {
      // parse message

      //emit right event for BLOC
      wsBloc.add(OpponentPointsUpdate(points: int.parse(message)));
      onMessage(message);
    });
  }

  void setOnErrorCallback(Function(dynamic, dynamic) onMessage) {
    wsClient.setOnError(onMessage);
  }

  void setOnCloseCallback(Function() onClosing) {
    wsClient.setOnClosing(onClosing);
  }

  void sendMessage(dynamic message) {
    wsClient.sendMessage(message);
    wsBloc.add(SendMessage(message: message));
  }
}
