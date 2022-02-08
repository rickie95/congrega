import 'dart:async';

import 'package:congrega/features/lifecounter/data/PlayerRepository.dart';
import 'package:congrega/features/lifecounter/data/game/GameRepository.dart';
import 'package:congrega/features/lifecounter/data/match/MatchClient.dart';
import 'package:congrega/features/lifecounter/model/Game.dart';
import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/LifeCounterState.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/match/MatchEvents.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/match/MatchState.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/features/profile_page/data/stats_repo.dart';
import 'package:congrega/features/users/UserRepository.dart';
import 'package:congrega/features/websocket/invitation_manager.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

import 'package:congrega/features/lifecounter/model/Match.dart';

import 'MatchRepository.dart';

class MatchController {
  static final Logger logger = Logger();

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

  void initState() => _controller.add(MatchStatus.updated);

  Stream<MatchStatus> get status async* {
    yield await matchInProgress().then((_) => MatchStatus.updated);
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
    logger.i("Fetched Match " + m.toString());
    Game? g = await gameRepository.fetchOnlineGame(m.gameList!.first.id!, opponent);
    logger.i("Fetched Game " + g.toString());
    return m;
  }

  Future<Match> _recoverMatch() async {
    return matchRepository.getCurrentMatch();
  }

  Future<Match> getCurrentMatch() async {
    return matchInProgress()
        .then((bool isInProgress) => isInProgress ? _recoverMatch() : newOfflineMatch());
  }

  Future<Match> createOnlineMatch(Message acceptedInvite) async {
    Match m = await matchRepository.createOnlineMatch(
        await playerRepository.getAuthenticatedPlayer(),
        playerRepository.fromUser(acceptedInvite.sender));

    Game? newGame = await gameRepository.newOnlineGame(Game(
        team: [await playerRepository.getAuthenticatedPlayer()],
        opponents: [Player.playerFromUser(acceptedInvite.sender)],
        parentMatch: m));

    Match createdMatch = m.copyWith(gameList: [newGame!]);
    matchRepository.updateMatch(createdMatch);
    _controller.add(MatchStatus.updated);
    gameRepository.updateGame(newGame);
    return createdMatch;
  }

  Future<bool> matchInProgress() async {
    return await matchRepository.checkPreviousMatch();
  }

  Match playerQuitsGame(Match match, Player player) {
    Match updatedMatch = match.copyWith(
        opponentScore:
            player.id == match.playerOne.id ? match.playerTwoScore + 1 : match.playerTwoScore,
        userScore:
            player.id == match.playerTwo.id ? match.playerOneScore + 1 : match.playerOneScore);
    matchRepository.updateMatch(updatedMatch).then((_) => _controller.add(MatchStatus.updated));
    _sendUpdateMessage(updatedMatch, player);

    return updatedMatch;
  }

  // Send notification only if resigning player is the current user
  void _sendUpdateMessage(Match updatedMatch, Player player) async {
    User currentUser = await KiwiContainer().resolve<UserRepository>().getUser();
    if (updatedMatch.type != MatchType.offline && player.id == currentUser.id) {
      matchRepository.syncMatch(updatedMatch);

      Message matchMessage = Message(
          type: MessageType.GAME,
          recipient: updatedMatch.opponentOf(currentUser).user,
          sender: currentUser,
          data: updatedMatch.id);
      KiwiContainer().resolve<InvitationManager>().sendMatchUpdate(matchMessage);
    }
  }

  Future<Match> playerResign(Match match, Player player) async {
    User currentUser = await KiwiContainer().resolve<UserRepository>().getUser();

    // 1) aggiorna il match e salva la statistica
    Match updatedMatch = match.copyWith(
        opponentScore:
            player.id == match.playerOne.id ? match.playerOneScore : match.playerOneScore + 1,
        userScore:
            player.id == match.playerTwo.id ? match.playerTwoScore : match.playerTwoScore + 1);

    KiwiContainer().resolve<StatsRepo>().addRecord(
        currentUser.id == match.playerOne.id ? match.playerTwo.username : match.playerOne.username,
        currentUser.id == match.playerOne.id ? match.playerOneScore : match.playerTwoScore,
        currentUser.id == match.playerOne.id ? match.playerTwoScore : match.playerOneScore);
    // se il player è l'utente corrente
    if (player.id == currentUser.id) {
      try {
        // 3) aggiorna via http
        KiwiContainer().resolve<MatchClient>().updateMatch(updatedMatch);
        // 4) invia una notifica all'avversario
        KiwiContainer().resolve<InvitationManager>().sendMatchUpdate(
              Message(
                  type: MessageType.MATCH,
                  recipient: updatedMatch.opponentOf(currentUser).user,
                  sender: currentUser,
                  data: "END"),
            );
      } catch (e) {
        logger.w(e.toString());
      }
    }

    // 2) chiudi il match ed eventuali game aperti
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

  Future<bool> isMatchInProgress() => matchInProgress();
}
