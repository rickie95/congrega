import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/features/tournaments/model/Tournament.dart';
import 'package:congrega/features/tournaments/data/repositories/TournamentRepository.dart';

class TournamentController {
  const TournamentController({required this.repository});

  final TournamentRepository repository;

  Future<List<Tournament>> getEventList() {
    return repository.getAllEvents();
  }

  List<Tournament> getParticipatedEvents() =>
      repository.getParticipatedEvents();
  List<Tournament> getCreatedEvents() => repository.getCreatedEvents();

  Future<Tournament> getEventDetails(String id) => repository.getEventById(id);

  Future<void> createNewEvent(Tournament t) => repository.newEvent(t);

  Future<Tournament> enrollUserInEvent(User user, Tournament tournament) =>
      repository.enrollUserAsPlayer(user, tournament);

  Tournament removeUserFromEvent(User user, Tournament tournament) {
    Set<User> updatedPlayerList = tournament.playerList.toSet();
    updatedPlayerList.remove(user);
    Tournament updatedTournament =
        tournament.copyWith(playerList: updatedPlayerList);
    // TODO: call to server to update, wait for result
    repository.updateEvent(updatedTournament);
    return updatedTournament;
  }

  Future<void> refreshTournamentList() => repository.refreshList();
}
