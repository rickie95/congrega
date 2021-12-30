import 'dart:async';

import 'package:congrega/features/lifecounter/model/Match.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/features/users/UserRepository.dart';
import 'package:congrega/features/websocket/websocket_client.dart';
import 'package:congrega/utils/Arcano.dart';
import 'package:flutter/foundation.dart';
import 'package:kiwi/kiwi.dart';
import 'package:uuid/uuid.dart';

class InvitationManager {
  late WebSocketClient wsClient;
  late User authenticatedUser;

  static Map<String, Completer<Message>> incoming = {};

  InvitationManager() {
    this.wsClient = new WebSocketClient(wsUri: Arcano.getWSPlayerUri(''));
    initWsClient();
  }

  void initWsClient() async {
    authenticatedUser = await KiwiContainer().resolve<UserRepository>().getUser();
    this.wsClient.setUri(Arcano.getWSPlayerUri(authenticatedUser.id));
  }

  void setOnMessageCallback(Function(Message) onMessage) {
    wsClient.setOnMessage((message) {
      // parse message
      print("[${authenticatedUser.username}] => " + message);
      Message m = Message.parseMessage(message);
      // forward only good messages
      if (m.type == MessageType.MALFORMED) return;

      if (incoming.containsKey(m.requestId)) {
        incoming[m.requestId]?.complete(m);
        incoming.remove(m.requestId);
      }
      onMessage(m);
    });
  }

  void setOnErrorCallback(Function(dynamic, dynamic) onMessage) {
    wsClient.setOnError(onMessage);
  }

  void setOnCloseCallback(Function() onClosing) {
    wsClient.setOnClosing(onClosing);
  }

  void sendMatchDetails(Message acceptedInvite, Match match) {
    final Message m = Message(
        type: MessageType.MATCH,
        recipient: acceptedInvite.sender,
        sender: getCurrentUser(),
        data: match.id,
        requestId: acceptedInvite.requestId);
    print("SENDING " + m.toString());

    wsClient.sendMessage(m.toString());
  }

  void sendMatchUpdate(Message message) {
    wsClient.sendMessage(message.toString());
  }

  Future<Message> sendInvite(User opponent) {
    final Completer<Message> completer = Completer<Message>();
    final String requestId = Message.idGenerator.v4();

    final Message m = Message(
        type: MessageType.CHALLENGES,
        recipient: opponent,
        sender: getCurrentUser(),
        requestId: requestId);
    incoming[requestId] = completer;

    wsClient.sendMessage(m.toString());
    return completer.future;
  }

  Future<Message> acceptInvite(Message invite) {
    // need a completer for the match info request
    final Completer<Message> completer = Completer<Message>();

    final Message m = Message(
      type: MessageType.ACCEPT,
      recipient: invite.sender,
      sender: getCurrentUser(),
      requestId: invite.requestId,
    );

    incoming[invite.requestId!] = completer;
    wsClient.sendMessage(m.toString());
    return completer.future;
  }

  void declineInvite(Message message, User opponent) {
    wsClient.sendMessage(Message(
            type: MessageType.DECLINE,
            recipient: opponent,
            sender: getCurrentUser(),
            requestId: message.requestId)
        .toString());
  }

  User getCurrentUser() {
    return authenticatedUser;
  }
}

class Message {
  final MessageType type;
  final User sender;
  final User recipient;
  final String? requestId;
  final String? data;

  static const int RECIPIENT_ID = 0;
  static const int RECIPIENT_USERNAME = 1;
  static const int REQUEST_ID = 2;
  static const int TYPE = 3;
  static const int SENDER_ID = 4;
  static const int SENDER_USERNAME = 5;
  static const int DATA = 6;

  static Uuid idGenerator = new Uuid();

  Message(
      {required this.type,
      required this.recipient,
      required this.sender,
      this.requestId,
      this.data});

  String get senderUsername => sender.username;
  String get senderId => sender.id;
  String get recipientUsername => recipient.username;
  String get recipientId => recipient.id;

  static Message parseMessage(String message) {
    List<String> tokens = message.split(" ");

    switch (tokens[TYPE]) {
      case "CHALLENGES":
        return Message(
            type: MessageType.CHALLENGES,
            sender: User(id: tokens[SENDER_ID], username: tokens[SENDER_USERNAME]),
            recipient: User(id: tokens[RECIPIENT_ID], username: tokens[RECIPIENT_USERNAME]),
            requestId: tokens[REQUEST_ID]);
      case "ACCEPT":
        return Message(
            type: MessageType.ACCEPT,
            sender: User(id: tokens[SENDER_ID], username: tokens[SENDER_USERNAME]),
            recipient: User(id: tokens[RECIPIENT_ID], username: tokens[RECIPIENT_USERNAME]),
            requestId: tokens[REQUEST_ID]);
      case "DECLINE":
        return Message(
            type: MessageType.DECLINE,
            sender: User(id: tokens[SENDER_ID], username: tokens[SENDER_USERNAME]),
            recipient: User(id: tokens[RECIPIENT_ID], username: tokens[RECIPIENT_USERNAME]),
            requestId: tokens[REQUEST_ID]);
      case "GAME":
        return Message(
            type: MessageType.GAME,
            sender: User(id: tokens[SENDER_ID], username: tokens[SENDER_USERNAME]),
            recipient: User(id: tokens[RECIPIENT_ID], username: tokens[RECIPIENT_USERNAME]),
            requestId: tokens[REQUEST_ID]);
      case "MATCH":
        return Message(
            type: MessageType.MATCH,
            sender: User(id: tokens[SENDER_ID], username: tokens[SENDER_USERNAME]),
            recipient: User(id: tokens[RECIPIENT_ID], username: tokens[RECIPIENT_USERNAME]),
            requestId: tokens[REQUEST_ID],
            data: tokens[DATA]);
      default:
        return Message(type: MessageType.MALFORMED, sender: User.empty, recipient: User.empty);
    }
  }

  @override
  String toString() {
    return "$recipientId $recipientUsername $requestId ${describeEnum(type)} $senderId $senderUsername ${data ?? ""}";
  }
}

enum MessageType { MALFORMED, CHALLENGES, ACCEPT, DECLINE, GAME, MATCH }
