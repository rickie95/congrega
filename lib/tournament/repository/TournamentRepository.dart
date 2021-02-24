import 'package:congrega/model/User.dart';
import 'package:congrega/tournament/model/Tournament.dart';

class TournamentRepository {
  // TODO: persistence on device
  static TournamentRepository _instance;

  static Set<Tournament> _participatedTournaments = {};
  static Set<Tournament> _createdTournaments = {};
  static Set<Tournament> _allEventsFromServer = {

    Tournament(
      name: "John's House Limited",
      type: "Limited",
      playerList: {
        User( username: "mikeMoz"),
        User( username: "DragonSlayer"),
        User( username: "BroccoliBob"),
      },
      adminList: {
        User( username: "BrokenImpala"),
        User( username: "JohnDoe"),
      },
      judgeList: {

      },
      startingTime: new DateTime(2021, 2, 21, 16, 0),
    ),

    Tournament(
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

  static TournamentRepository getInstance() {
    if(_instance == null)
      _instance = new TournamentRepository();

    return _instance;
  }

  void addParticipatedEvent(Tournament updatedTournament) {
    _participatedTournaments.add(updatedTournament);
  }

}