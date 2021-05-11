import 'dart:convert';

import 'package:congrega/features/tournaments/data/datasources/TournamentHttpClient.dart';
import 'package:congrega/features/tournaments/model/Tournament.dart';
import 'package:congrega/utils/Arcano.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'UserHttpClient_test.mocks.dart';


@GenerateMocks([http.Client])
void main(){

  group('TournamentHttpClient ', (){

    test('should retrieves a list of events.', () async {
      Tournament t1 = new Tournament(
          id: "869bfb73-e357-499d-882e-8230c7b59561",
          name: "Event #1",
          playerList: {},
          adminList: {},
          judgeList: {},
          type: "Limited",
          startingTime: new DateTime.now(),
          status: TournamentStatus.scheduled,
          round: 0
      );

      List<Tournament> eventList = [t1];

      final client = MockClient();
      TournamentHttpClient tournamentClient = new TournamentHttpClient(client);

      when(client.get(Uri(path: Arcano.EVENTS_URL))).thenAnswer(
          (_) async => http.Response(jsonEncode(eventList), 200));

      List<Tournament> returnedEventList = await tournamentClient.getTournamentList();

      expect(returnedEventList, hasLength(1));
      expect(returnedEventList, contains(
        t1
       ));
    });

  });

}