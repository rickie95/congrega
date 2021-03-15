import 'dart:convert';

import 'package:congrega/features/tournaments/model/Tournament.dart';
import 'package:congrega/httpClients/exceptions/HttpExceptions.dart';
import 'package:congrega/utils/Arcano.dart';
import 'package:http/http.dart' as http;

class TournamentHttpClient {

  TournamentHttpClient(this.httpClient);

  final http.Client httpClient;

 Future<List<Tournament>> getTournamentList() async {
    final response = await httpClient.get(Uri(path: Arcano.EVENTS_URL));

    switch(response.statusCode){
      case(200):
      // Create a collection from response's body
        final List<dynamic> jsonBody = jsonDecode(response.body) as List;
        return jsonBody.map((jsonObj) => Tournament.fromJson(jsonObj)).toList();
      case(404):
        throw NotFoundException();
      case(500):
        throw ServerErrorException();
    }
    throw OtherErrorException();
  }

}