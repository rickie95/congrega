import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketClient {
  static const RETRY_INTERVAL_SECONDS = 10;

  late WebSocketChannel _channel;

  late Function(dynamic)? onMessage;
  late Function()? onClosing;
  late Function(dynamic, dynamic)? onError;

  late StreamSubscription? wsStreamSub;

  bool _channelIsOpen = false;

  Uri wsUri;

  WebSocketClient({required this.wsUri, this.onMessage, this.onClosing, this.onError}) {
    wsStreamSub = null;
    _connect();
  }

  void sendMessage(String message) {
    if (this._channelIsOpen) _channel.sink.add(message);
  }

  void setOnMessage(Function(dynamic) onMessage) {
    this.onMessage = onMessage;
  }

  void setOnClosing(Function() onClosing) {
    this.onClosing = onClosing;
  }

  void setOnError(Function(dynamic, dynamic) onError) {
    this.onError = onError;
  }

  void updateStream() {
    if (this.wsStreamSub != null) this.wsStreamSub?.cancel();
    wsStreamSub = registerCallbacks();
  }

  StreamSubscription<dynamic> registerCallbacks() {
    _channelIsOpen = true;
    return _channel.stream.listen((data) {
      if (this.onMessage != null) this.onMessage!(data);
    }, onDone: () {
      if (this.onClosing != null) this.onClosing!();
      _channelIsOpen = false;
      _channel.sink.close();
      Future.delayed(Duration(seconds: RETRY_INTERVAL_SECONDS), _connect);
    }, onError: (error, stacktrace) {
      if (error is WebSocketChannelException) {
        _channelIsOpen = false;
        if (this.onError != null) this.onError!(error, stacktrace);
      }
    });
  }

  void _connect() {
    _channel = WebSocketChannel.connect(this.wsUri);
    updateStream();
  }

  void setUri(Uri uri) {
    this.wsUri = uri;
    _connect();
  }
}
