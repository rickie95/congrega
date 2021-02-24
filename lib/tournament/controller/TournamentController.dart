import 'package:congrega/model/User.dart';
import 'package:congrega/tournament/model/Tournament.dart';
import 'package:congrega/tournament/repository/TournamentRepository.dart';
import 'package:congrega/tournament/bloc/TournamentState.dart';

class TournamentController {

  static TournamentController _instance;

  static TournamentController getInstance(){
    if(_instance == null)
      _instance = new TournamentController(repo: TournamentRepository.getInstance());

    return _instance;
  }

  const TournamentController({
    this.repo
  });

  final TournamentRepository repo;

  List<Tournament> getEventList(){
    return _instance.repo.getAllEvents();
  }

  List<Tournament> getParticipatedEvents() => _instance.repo.getParticipatedEvents();
  List<Tournament> getCreatedEvents() => _instance.repo.getCreatedEvents();
  
  Tournament enrollUserInEvent(User user, Tournament tournament){
    Set<User> updatedPlayerList =  tournament.playerList.toSet();
    updatedPlayerList.add(user);
    Tournament updatedTournament = tournament.copyWith(playerList: updatedPlayerList);
    // TODO: call to server to update, wait for result
    _instance.repo.updateEvent(updatedTournament);
    _instance.repo.addParticipatedEvent(updatedTournament);
    return updatedTournament;
  }

  TournamentState getStateForEvent(Tournament event){
    return TournamentState(

    );
  }

  Tournament removeUserFromEvent(User user, Tournament tournament) {
    Set<User> updatedPlayerList =  tournament.playerList.toSet();
    updatedPlayerList.remove(user);
    Tournament updatedTournament = tournament.copyWith(playerList: updatedPlayerList);
    // TODO: call to server to update, wait for result
    _instance.repo.updateEvent(updatedTournament);
    return updatedTournament;
  }

}