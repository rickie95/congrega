import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/features/tournaments/model/Tournament.dart';
import 'package:congrega/features/tournaments/data/repositories/TournamentRepository.dart';


class TournamentController {

   const TournamentController({
    required this.repository
  });

  final TournamentRepository repository;

  List<Tournament> getEventList(){
    return repository.getAllEvents();
  }

  List<Tournament> getParticipatedEvents() =>repository.getParticipatedEvents();
  List<Tournament> getCreatedEvents() => repository.getCreatedEvents();
  
  Tournament enrollUserInEvent(User user, Tournament tournament){
    Set<User> updatedPlayerList =  tournament.playerList.toSet();
    updatedPlayerList.add(user);
    Tournament updatedTournament = tournament.copyWith(playerList: updatedPlayerList);
    // TODO: call to server to update, wait for result
    repository.updateEvent(updatedTournament);
    repository.addParticipatedEvent(updatedTournament);
    return updatedTournament;
  }

  Tournament removeUserFromEvent(User user, Tournament tournament) {
    Set<User> updatedPlayerList =  tournament.playerList.toSet();
    updatedPlayerList.remove(user);
    Tournament updatedTournament = tournament.copyWith(playerList: updatedPlayerList);
    // TODO: call to server to update, wait for result
    repository.updateEvent(updatedTournament);
    return updatedTournament;
  }

}