import 'dart:convert';

import 'package:congrega/features/authentication/AuthenticationRepository.dart';
import 'package:congrega/features/exceptions/HttpExceptions.dart';
import 'package:congrega/utils/Arcano.dart';
import 'package:congrega/features/lifecounter/model/Match.dart';
import 'package:http/http.dart' as http;
import 'package:kiwi/kiwi.dart';

class MatchClient {
  final http.Client httpClient;

  MatchClient({required this.httpClient});

  Future<Match> createMatch(Match m) async {
    String? token = await KiwiContainer().resolve<AuthenticationRepository>().getToken();
    dynamic matchMap = Match.encodeArcanoJson(m);
    final http.Response response = await httpClient.post(Arcano.getMatchUri(),
        body: jsonEncode(matchMap),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ${token!}'});

    switch (response.statusCode) {
      case (201):
        return Match.decodeArcanoJson(jsonDecode(response.body));
      case (400):
        print(response.body);
        throw BadRequestException();
      case (500):
        print(response.body);
        throw ServerErrorException();
      default:
        print(response.body);
        throw OtherErrorException();
    }
  }

  Future<Match> getMatchById(String matchId) async {
    final http.Response response = await httpClient.get(Arcano.getMatchUri(matchId: matchId));

    switch (response.statusCode) {
      case (200):
        return Match.decodeArcanoJson(jsonDecode(response.body));
      case (400):
        print(response.body);
        throw BadRequestException();
      case (404):
        print(response.body);
        throw NotFoundException();
      case (500):
        print(response.body);
        throw ServerErrorException();
      default:
        print(response.body);
        throw OtherErrorException();
    }
  }
}
