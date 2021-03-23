import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/features/tournaments/model/Tournament.dart';
import 'package:uuid/uuid.dart';

class TournamentRepository {

  static Set<Tournament> _participatedTournaments = {};
  static Set<Tournament> _createdTournaments = {};
  static Set<Tournament> _allEventsFromServer = {

    Tournament(
      id: BigInt.from(1),
      status: TournamentStatus.scheduled,
      round: 0,
      name: "John's House Limited",
      type: "Limited",
      playerList: {
        User(
            id: Uuid().toString(),
            username: "mikeMoz"
        ),
        User(
            id: Uuid().toString(),
            username: "DragonSlayer"
        ),
        User(
            id: Uuid().toString(),
            username: "BroccoliBob"
        ),
      },
      adminList: {
        User(
            id: Uuid().toString(),
            username: "BrokenImpala"
        ),
        User(
            id: Uuid().toString(),
            username: "JohnDoe"
        ),
      },
      judgeList: {

      },
      startingTime: new DateTime(2021, 2, 21, 16, 0),
    ),

    Tournament(
      id: BigInt.from(2),
      status: TournamentStatus.scheduled,
      round: 0,
      name: "Magic Mike Constructed",
      type: "Constructed",
      playerList: {

      },
      adminList: {

      },
      judgeList: {

      },
      startingTime: new DateTime(2021, 2, 22, 17, 0),
    ),

    Tournament(
      id: BigInt.from(3),
      status: TournamentStatus.scheduled,
      round: 0,
      name: "Calamity Store Draft",
      type: "Draft",
      playerList: {

      },
      adminList: {

      },
      judgeList: {

      },
      startingTime: new DateTime(2021, 2, 14, 10, 0),
    )

  };

  List<Tournament> getAllEvents() {
    return _allEventsFromServer.toList();
  }

  List<Tournament> getParticipatedEvents(){
    return _participatedTournaments.toList();
  }

  List<Tournament> getCreatedEvents(){
    return _createdTournaments.toList();
  }

  void updateEvent(Tournament event){}

  Set<Tournament> getEventsParticipatedByUser(User user){
    return _participatedTournaments;
  }

  void addParticipatedEvent(Tournament updatedTournament) {
    _participatedTournaments.add(updatedTournament);
  }

}