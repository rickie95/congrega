import 'dart:convert';

import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/features/tournaments/model/Tournament.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Tournament ', () {
    test('should produce a correct json.', () {
      User user = User(id: '1', name: 'Mike', username: 'mike', password: 'secret');
      User otherUser = User(id: '2', name: 'Bob', username: 'bob', password: 'secret');

      User admin = User(id: '3', name: 'ADMIN', username: 'admin', password: 'secret');

      Tournament tournament = new Tournament(
          id: "869bfb73-e357-499d-882e-8230c7b59561",
          name: "Event #1",
          playerList: {user, otherUser},
          adminList: {admin},
          judgeList: {},
          type: "Limited",
          startingTime: new DateTime.now(),
          status: TournamentStatus.SCHEDULED,
          round: 0);

      String jsonBody = jsonEncode(tournament);
      print(jsonBody);

      Tournament recoveredTournament = Tournament.fromJson(jsonDecode(jsonBody));

      expect(recoveredTournament.id, tournament.id);
      expect(recoveredTournament.name, tournament.name);
      expect(recoveredTournament.playerList, tournament.playerList);
      expect(recoveredTournament.adminList, tournament.adminList);
      expect(recoveredTournament.judgeList, tournament.judgeList);
      expect(recoveredTournament.type, tournament.type);
      expect(recoveredTournament.startingTime, tournament.startingTime);
      expect(recoveredTournament.status, tournament.status);
      expect(recoveredTournament.round, tournament.round);
    });
  });
}
