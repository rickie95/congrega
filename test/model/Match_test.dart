import 'dart:convert';
import 'dart:io';

import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/utils/Arcano.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:congrega/features/lifecounter/model/Match.dart';
import 'package:http/http.dart' as http;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  test('Match to and from json', () {
    Match match = Match(
        id: 'match-001',
        playerOne: Player.playerFromUser(
            User(id: 'user-001', username: 'mike', name: 'Mike', password: 'secret1')),
        playerTwo: Player.playerFromUser(
            User(id: 'user-002', username: 'brad', name: 'Brad', password: 'secret2')),
        playerTwoScore: 1,
        playerOneScore: 2,
        type: MatchType.offline);

    String jsonBody = jsonEncode(match);

    Match recoveredMatch = Match.fromJson(jsonDecode(jsonBody));

    expect(recoveredMatch.id, equals(match.id));
    expect(recoveredMatch.type, equals(match.type));
    expect(recoveredMatch.playerOne, equals(match.playerOne));
  });

  test('Match to json compatible for Arcano', () async {
    http.Client httpClient = http.Client();

    User userOne = User(id: '0290b4e0-b88f-4ea7-ba50-2794970a8a57', username: 'LGG2');
    User userTwo = User(id: '7584c21b-5b6c-4820-9dde-57f6a31d31d3', username: 'pixel');

    Match match = Match(
        playerOne: Player.playerFromUser(userOne),
        playerTwo: Player.playerFromUser(userTwo),
        playerTwoScore: 1,
        playerOneScore: 2,
        type: MatchType.offline);

    Map<String, dynamic> matchMap = Match.encodeArcanoJson(match);

    String token =
        "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJwaXhlbCJ9.lTxH4sbv4HQI58QX7mpePxiSYg3QqiXtdkkpbUCdmxU";
    http.Response response = await httpClient.post(Arcano.getMatchUri(),
        body: jsonEncode(matchMap),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'});

    print(response.body);
    expect(response.statusCode, 201);
  });
}
