import 'dart:convert';

import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/features/tournaments/data/datasources/TournamentHttpClient.dart';
import 'package:congrega/features/tournaments/model/Tournament.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TournamentRepository {
  static Set<String> _participatedTournamentsID = {};
  static Set<Tournament> _createdTournaments = {};
  static Set<Tournament> _eventsList = {};

  TournamentRepository({required this.tournamentHttpClient}) {
    _fetchTournamentList();
  }

  final TournamentHttpClient tournamentHttpClient;

  Future<List<Tournament>> getAllEvents() {
    return tournamentHttpClient.getTournamentList();
  }

  Future<Tournament> getEventById(String uuid) {
    return tournamentHttpClient.getEventByUUID(uuid);
  }

  Future<void> newEvent(Tournament t) => tournamentHttpClient.sendNewEvent(t);

  Future<Tournament> enrollUserAsPlayer(User user, Tournament tournament) {
    return tournamentHttpClient.enrollUserInTournament(tournament.id, user);
  }

  Future<void> _fetchTournamentList() async {
    _eventsList.addAll(await tournamentHttpClient.getTournamentList());
  }

  List<Tournament> getParticipatedEvents() {
    return _eventsList
        .where((element) => _participatedTournamentsID.contains(element.id))
        .toList();
  }

  List<Tournament> getCreatedEvents() {
    return _createdTournaments.toList();
  }

  void updateEvent(Tournament event) {}

  List<Tournament> getEventsParticipatedByUser(User user) {
    return _eventsList
        .where((element) => (_participatedTournamentsID.contains(element.id) &&
            element.playerList.contains(user)))
        .toList();
  }

  Future<void> addParticipatedEvent(Tournament updatedTournament) async {
    _participatedTournamentsID.add(updatedTournament.id);
    SharedPreferences storage = await SharedPreferences.getInstance();
    storage.setString(
        "EVENTS_IN_PROGRESS", jsonEncode(_participatedTournamentsID));
  }

  Future<void> _loadParticipatedEvents() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String? encodedIDs = storage.getString("EVENTS_IN_PROGRESS");
    if (encodedIDs != null && encodedIDs.isNotEmpty)
      _participatedTournamentsID = jsonDecode(encodedIDs);
  }

  Future<void> refreshList() => _fetchTournamentList();
}
