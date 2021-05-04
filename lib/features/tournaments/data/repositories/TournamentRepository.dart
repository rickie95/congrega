import 'dart:convert';

import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/features/tournaments/model/Tournament.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class TournamentRepository {

  static Set<String> _participatedTournamentsID = {};
  static Set<Tournament> _createdTournaments = {};
  static Set<Tournament> _allEventsFromServer = {

    Tournament(
      id: "1",
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
      id: "2",
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
      startingTime: new DateTime(2021, 3, 22, 17, 0),
    ),

    Tournament(
      id: "3",
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
      startingTime: new DateTime(2021, 4, 14, 10, 0),
    )

  };
  
  TournamentRepository() {
    _loadParticipatedEvents()
    ;
  }

  List<Tournament> getAllEvents() {
    return _allEventsFromServer.toList();
  }

  List<Tournament> getParticipatedEvents(){
    return _allEventsFromServer.where((element) => _participatedTournamentsID.contains(element.id)).toList();
  }

  List<Tournament> getCreatedEvents(){
    return _createdTournaments.toList();
  }

  void updateEvent(Tournament event){}

  List<Tournament> getEventsParticipatedByUser(User user){
    return _allEventsFromServer
        .where((element) => (_participatedTournamentsID.contains(element.id) &&
        element.playerList.contains(user))).toList();
  }

  Future<void> addParticipatedEvent(Tournament updatedTournament) async {
    _participatedTournamentsID.add(updatedTournament.id);
    SharedPreferences storage = await SharedPreferences.getInstance();
    storage.setString("EVENTS_IN_PROGRESS", jsonEncode(_participatedTournamentsID));
  }

  Future<void> _loadParticipatedEvents() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String? encodedIDs = storage.getString("EVENTS_IN_PROGRESS");
    if(encodedIDs != null && encodedIDs.isNotEmpty)
      _participatedTournamentsID = jsonDecode(encodedIDs);
  }

}