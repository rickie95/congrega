import 'package:congrega/features/exceptions/HttpExceptions.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/features/tournaments/data/datasources/TournamentHttpClient.dart';
import 'package:congrega/features/tournaments/model/Tournament.dart';
import 'package:congrega/utils/Arcano.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;

User admin = new User(id: "299a00fa-7566-4bdc-a70f-141e07d2bd43", username: "morbidezzaRick");
Tournament expectedTournament = new Tournament(
    id: "04df3c42-8bbc-493c-a0e3-4cd273164be9",
    name: "Ritrovo #37",
    playerList: {},
    adminList: {admin},
    judgeList: {},
    type: "Limited",
    startingTime: DateTime.parse("2021-05-07T12:45:00"),
    status: TournamentStatus.SCHEDULED,
    round: 0);

void main() {
  test('GetAllEvents via GraphQL', () async {
    GraphQLClient client = GraphQLClient(
      link: new HttpLink(Arcano.getGraphQlUri().toString()),
      // The default store is the InMemoryStore, which does NOT persist to disk
      cache: GraphQLCache(store: InMemoryStore()),
    );

    //final response = await httpClient.get(Arcano.getEventsUri());
    String queryBody = """
      { eventList { 
          id 
          name 
          status 
          type 
          startingTime 
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
          round 
          } 
        }
    """;

    QueryOptions queryOpt = QueryOptions(document: gql(queryBody));

    final QueryResult result = await client.query(queryOpt);

    if (result.hasException) {
      print(result.exception.toString());
      throw OtherErrorException();
    }

    if (result.data == null) throw Exception("data is null");

    final List<Tournament> eventList = (result.data!['eventList'] as List<dynamic>)
        .map((dynamic element) => Tournament.fromJson(element))
        .toList();

    expect(eventList, contains(expectedTournament));
    Tournament fetchedTournament =
        eventList.firstWhere((element) => element.id == expectedTournament.id);

    expect(fetchedTournament.name, equals(expectedTournament.name));
    expect(fetchedTournament.status, equals(expectedTournament.status));
    expect(fetchedTournament.type, equals(expectedTournament.type));
    expect(fetchedTournament.round, equals(expectedTournament.round));
    expect(fetchedTournament.startingTime, equals(expectedTournament.startingTime));
    expect(fetchedTournament.adminList, contains(admin));

    User fetchedAdmin = fetchedTournament.adminList.firstWhere((element) => element.id == admin.id);

    expect(fetchedAdmin.name, equals(admin.name));
  });

  test('GetEventByID via GraphQL', () async {
    TournamentHttpClient client =
        TournamentHttpClient(restClient: http.Client(), graphQLClient: new ArcanoGraphQLClient());

    Tournament fetchedTournament = await client.getEventByUUID(expectedTournament.id);

    expect(fetchedTournament.name, equals(expectedTournament.name));
    expect(fetchedTournament.status, equals(expectedTournament.status));
    expect(fetchedTournament.type, equals(expectedTournament.type));
    expect(fetchedTournament.round, equals(expectedTournament.round));
    expect(fetchedTournament.startingTime, equals(expectedTournament.startingTime));
    expect(fetchedTournament.adminList, contains(admin));

    User fetchedAdmin = fetchedTournament.adminList.firstWhere((element) => element.id == admin.id);

    expect(fetchedAdmin.name, equals(admin.name));
  });
}
