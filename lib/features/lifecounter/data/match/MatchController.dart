import 'dart:async';

import 'package:congrega/features/lifecounter/data/PlayerRepository.dart';
import 'package:congrega/features/lifecounter/data/game/GameRepository.dart';
import 'package:congrega/features/lifecounter/model/Game.dart';
import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/LifeCounterState.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/match/MatchState.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/features/users/UserRepository.dart';
import 'package:congrega/features/websocket/invitation_manager.dart';
import 'package:rxdart/rxdart.dart';

import 'package:congrega/features/lifecounter/model/Match.dart';

import 'MatchRepository.dart';

class MatchController {
  MatchController(
      {required this.matchRepository,
      required this.playerRepository,
      required this.userRepository,
      required this.gameRepository});

  final StreamController<MatchStatus> _controller = new BehaviorSubject();
  final MatchRepository matchRepository;
  final PlayerRepository playerRepository;
  final UserRepository userRepository;
  final GameRepository gameRepository;

  Stream<GameStatus> get gameStatus async* {
    yield* gameRepository.status;
  }

  Stream<MatchStatus> get status async* {
    yield await _matchInProgress().then((_) => MatchStatus.updated);
    yield* _controller.stream;
  }

  Future<Match> newOfflineMatch({User? opponent}) async {
    gameRepository.newGame(
      Game(team: [
        await playerRepository.getAuthenticatedPlayer()
      ], opponents: [
        opponent == null ? playerRepository.genericOpponent() : Player.playerFromUser(opponent)
      ]),
    );
    return matchRepository.newOfflineMatch(new Match(
        id: '-',
        playerOne: await playerRepository.getAuthenticatedPlayer(),
        playerTwo: opponent != null
            ? playerRepository.fromUser(opponent)
            : playerRepository.genericOpponent(),
        playerOneScore: 0,
        playerTwoScore: 0,
        type: MatchType.offline));
  }

  Future<Match> fetchOnlineMatch(User opponent, String matchId) async {
    Match m = await matchRepository.fetchOnlineMatch(matchId);
    gameRepository.fetchOnlineGame(m.gameList!.first.id!, opponent);
    return m;
  }

  Future<Match> _recoverMatch() async {
    return matchRepository.getCurrentMatch();
  }

  Future<Match> getCurrentMatch() async {
    return _matchInProgress()
        .then((bool isInProgress) => isInProgress ? _recoverMatch() : newOfflineMatch());
  }

  Future<Match> createOnlineMatch(Message acceptedInvite) async {
    Game? newGame = await gameRepository.newOnlineGame(Game(
      team: [await playerRepository.getAuthenticatedPlayer()],
      opponents: [Player.playerFromUser(acceptedInvite.sender)],
    ));
    return matchRepository
        .createOnlineMatch(await playerRepository.getAuthenticatedPlayer(),
            playerRepository.fromUser(acceptedInvite.sender),
            game: newGame)
        .then((Match m) {
      _controller.add(MatchStatus.updated);
      return m;
    });
  }

  Future<bool> _matchInProgress() async {
    return await matchRepository.checkPreviousMatch();
  }

  Match playerQuitsGame(Match match, Player player) {
    Match updatedMatch = match.copyWith(
        opponentScore:
            player.id == match.playerOne.id ? match.playerTwoScore + 1 : match.playerTwoScore,
        userScore:
            player.id == match.playerTwo.id ? match.playerOneScore + 1 : match.playerOneScore);
    matchRepository.updateMatch(updatedMatch).then((_) => _controller.add(MatchStatus.updated));

    return updatedMatch;
  }

  Match playerResign(Match match, Player player) {
    Match updatedMatch = match.copyWith(
        opponentScore: player.id == match.playerOne.id ? 2 : 0,
        userScore: player.id == match.playerTwo.id ? 2 : 0);
    matchRepository.endMatch(updatedMatch).then((_) => _controller.add(MatchStatus.ended));
    gameRepository.endGame();
    return updatedMatch;
  }

  Match playerWinsGame(Match match, Player player) {
    Match updatedMatch = match.copyWith(
        opponentScore:
            player.id == match.playerTwo.id ? match.playerTwoScore + 1 : match.playerTwoScore,
        userScore:
            player.id == match.playerOne.id ? match.playerOneScore + 1 : match.playerOneScore);
    // call repo and update game
    return updatedMatch;
  }

  void dispose() => _controller.close();

  Future<Game> getCurrentGame() => gameRepository.getCurrentGame();
}
