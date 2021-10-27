import 'dart:convert';

import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/features/tournaments/model/Tournament.dart';
import 'package:congrega/features/exceptions/HttpExceptions.dart';
import 'package:congrega/utils/Arcano.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;

class TournamentHttpClient {
  TournamentHttpClient({required this.graphQLClient, required this.restClient});

  final ArcanoGraphQLClient graphQLClient;
  final http.Client restClient;

  static final QueryOptions fetchAllQueryOptions = QueryOptions(
      document: gql(getAllTournamentsQuery),
      fetchPolicy: FetchPolicy.cacheAndNetwork);

  static final String getAllTournamentsQuery = """
      { eventList { 
          id 
          name 
          status 
          type 
          startingTime
          round
          playerList{
            id
            username
          }
          adminList {
            id
            username
          }
          judgeList {
            id
            username
          }
          } 
        }
    """;

  static String getTournamentByUUIDQuery(String uuid) => """
  {  
    eventById(id : "$uuid") {
      id 
      name 
      status 
      type 
      startingTime
      round
      playerList { 
        id 
        username 
      } 
      adminList { 
        id 
        username 
      } 
      judgeList { 
        id 
        username 
      }
    }
  }
  """;

  Future<List<Tournament>> getTournamentList() async {
    final QueryResult result = await graphQLClient.query(fetchAllQueryOptions);

    if (result.hasException) handleException(result.exception);

    if (result.data == null) throw Exception("data is null");

    return (result.data!['eventList'] as List<dynamic>)
        .map((dynamic element) => Tournament.fromJson(element))
        .toList();
  }

  void handleException(OperationException? operationException) {
    if (operationException != null) {
      if (operationException.linkException is ServerException)
        throw ConnectionException();
    }

    throw OtherErrorException();
  }

  Future<Tournament> getEventByUUID(String uuid) async {
    QueryOptions queryOpt =
        QueryOptions(document: gql(getTournamentByUUIDQuery(uuid)));

    final QueryResult result = await graphQLClient.query(queryOpt);

    if (result.hasException) handleException(result.exception);

    if (result.data == null) throw Exception("data is null");

    return Tournament.fromJson(result.data!["eventById"] as dynamic);
  }

  Future<void> sendNewEvent(Tournament t) async {
    final http.Response response = await restClient.post(Arcano.getEventsUri(),
        body: jsonEncode(t.toBriefJson()),
        headers: {'Content-Type': 'application/json'});

    switch (response.statusCode) {
      case (201):
        return;
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

  Future<Tournament> enrollUserInTournament(
      String tournamentUIID, User user) async {
    final http.Response response = await restClient
        .post(Arcano.enrollUserInEventUri(tournamentUIID, user.id.toString()));

    switch (response.statusCode) {
      case (202):
        return Tournament.fromJson(jsonDecode(response.body));
      case (404):
        throw NotFoundException();
      case (500):
        throw ServerErrorException();
      default:
        throw OtherErrorException();
    }
  }
}
