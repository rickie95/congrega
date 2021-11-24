import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/features/tournaments/data/datasources/TournamentHttpClient.dart';
import 'package:congrega/features/tournaments/model/Tournament.dart';
import 'package:congrega/utils/Arcano.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

Tournament tournament = new Tournament(
    id: "8bfedab3-9019-4869-bd37-7f569ae32a45",
    name: "Magic Fest @ Firenze Rock",
    playerList: {},
    adminList: {
      User(
          id: "a273be4d-9597-48a7-a10d-c4a29fb6750b",
          username: "morbidezzaRick")
    },
    judgeList: {},
    type: "Limited",
    startingTime: DateTime.parse("2021-07-07T12:45:00"),
    status: TournamentStatus.SCHEDULED,
    round: 0);

@GenerateMocks([http.Client, ArcanoGraphQLClient])
void main() {
  group('TournamentHttpClient', () {
    test('should retrieves a list of events.', () async {
      ArcanoGraphQLClient graphQLClient = ArcanoGraphQLClient();

      TournamentHttpClient tournamentClient = new TournamentHttpClient(
          restClient: http.Client(), graphQLClient: graphQLClient);

      List<Tournament> returnedEventList =
          await tournamentClient.getTournamentList();

      expect(returnedEventList, hasLength(lessThan(10)));
      expect(returnedEventList, contains(tournament));
    });

    test("should retrive a single event by its ID", () async {
      ArcanoGraphQLClient graphQLClient = ArcanoGraphQLClient();

      TournamentHttpClient tournamentClient = new TournamentHttpClient(
          restClient: http.Client(), graphQLClient: graphQLClient);

      Tournament returnedEvent =
          await tournamentClient.getEventByUUID(tournament.id);

      expect(returnedEvent, equals(tournament));
    });

    test("should successfully send a new event to the server", () async {
      http.Client client = http.Client();

      TournamentHttpClient tournamentClient = new TournamentHttpClient(
          restClient: client, graphQLClient: ArcanoGraphQLClient());

      expect(tournamentClient.sendNewEvent(tournament), returnsNormally);
    });
  });
}
