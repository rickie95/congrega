import 'dart:convert';

import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:congrega/features/loginSignup/model/User.dart';

import 'package:congrega/features/lifecounter/model/Match.dart';
import 'package:congrega/utils/Arcano.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const title = 'WebSocket Demo';
    return const MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late http.Client httpClient;

  @override
  void initState() {
    httpClient = new http.Client();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [const SizedBox(height: 24)],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ),
    );
  }

  void _sendMessage() async {
    User userOne = User(id: '0290b4e0-b88f-4ea7-ba50-2794970a8a57', username: 'LGG2');
    User userTwo = User(id: '7584c21b-5b6c-4820-9dde-57f6a31d31d3', username: 'pixel');

    Match match = Match(
        playerOne: Player.playerFromUser(userOne),
        playerTwo: Player.playerFromUser(userTwo),
        playerTwoScore: 1,
        playerOneScore: 2,
        type: MatchType.offline);
    dynamic matchMap = Match.encodeArcanoJson(match);
    String token =
        "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJwaXhlbCJ9.5zzAnEu_MgS9lnzaZLQ17SV7yk0f_Mb3-Cq58n2d9Oc";
    http.Response response = await httpClient.post(Arcano.getMatchUri(),
        body: jsonEncode(matchMap),
        headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"});

    print(response.statusCode);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
