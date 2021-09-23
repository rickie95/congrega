import 'dart:async';

import 'package:congrega/features/lifecounter/data/PlayerRepository.dart';
import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/match/MatchState.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:rxdart/rxdart.dart';

import 'package:congrega/features/lifecounter/model/Match.dart';

import 'MatchRepository.dart';

class MatchController {
  MatchController({required this.matchRepository, required this.playerRepository});

  final StreamController<MatchStatus> _controller = new BehaviorSubject();
  final MatchRepository matchRepository;
  final PlayerRepository playerRepository;

  Stream<MatchStatus> get status async* {
    yield await _matchInProgress().then((_) => MatchStatus.updated);
    yield* _controller.stream;
  }

  Future<Match> newOfflineMatch({User? opponent}) async {
    return matchRepository.newOfflineMatch(new Match(
        id: '-',
        user: await playerRepository.getAuthenticatedPlayer(),
        opponent: opponent != null
            ? playerRepository.fromUser(opponent)
            : playerRepository.genericOpponent(),
        userScore: 0,
        opponentScore: 0,
        type: MatchType.offline));
  }

  Future<Match> _recoverMatch() async {
    return matchRepository.getCurrentMatch();
  }

  Future<Match> getCurrentMatch() async {
    return _matchInProgress()
        .then((bool isInProgress) => isInProgress ? _recoverMatch() : newOfflineMatch());
  }

  Future<void> createOnlineMatch(Match match) async {
    // usato dal tournamentBloc/controller per creare un nuovo match di un torneo
    // ad un certo punto deve salvarlo sul matchRepo
    // e poi sparare un evento per notificare il match bloc
    matchRepository.persistMatch(match);
    _controller.add(MatchStatus.updated);
  }

  Future<bool> _matchInProgress() async {
    return await matchRepository.checkPreviousMatch();
  }

  Match playerQuitsGame(Match match, Player player) {
    Match updatedMatch = match.copyWith(
        opponentScore: player.id == match.user.id ? match.opponentScore + 1 : match.opponentScore,
        userScore: player.id == match.opponent.id ? match.userScore + 1 : match.userScore);
    matchRepository.updateMatch(updatedMatch).then((_) => _controller.add(MatchStatus.updated));

    return updatedMatch;
  }

  Match playerResign(Match match, Player player) {
    Match updatedMatch = match.copyWith(
        opponentScore: player.id == match.user.id ? 2 : 0,
        userScore: player.id == match.opponent.id ? 2 : 0);
    matchRepository.endMatch(updatedMatch).then((_) => _controller.add(MatchStatus.ended));
    return updatedMatch;
  }

  Match playerWinsGame(Match match, Player player) {
    Match updatedMatch = match.copyWith(
        opponentScore:
            player.id == match.opponent.id ? match.opponentScore + 1 : match.opponentScore,
        userScore: player.id == match.user.id ? match.userScore + 1 : match.userScore);
    // call repo and update game
    return updatedMatch;
  }

  void dispose() => _controller.close();
}
