import 'dart:async';

import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:congrega/features/match/presentation/bloc/MatchState.dart';
import 'package:rxdart/rxdart.dart';

import 'package:congrega/features/match/model/Match.dart';

import 'MatchRepository.dart';

class MatchController {

  MatchController({
    required this.matchRepository
  });

  final StreamController<MatchStatus> _controller = new BehaviorSubject();
  final MatchRepository matchRepository;

  Stream<MatchStatus> get status async* {
    yield* _controller.stream;
  }

  void dispose() => _controller.close();

  Match playerQuitsGame(Match match, Player player) {
    Match updatedMatch = match.copyWith(
        opponentScore: player.id == match.user.id ? match.opponentScore + 1 : match.opponentScore,
        userScore: player.id == match.opponent.id ? match.userScore + 1: match.userScore
    );
    // call repo for update
    return updatedMatch;
  }

  Match playerResign(Match match, Player player) {
    Match updatedMatch = match.copyWith(
        opponentScore: player.id == match.user.id ? 2 : 0,
        userScore: player.id == match.opponent.id ? 2: 0
    );
    // call repo and notify match ending
    return updatedMatch;
  }

  Match playerWinsGame(Match match, Player player) {
    Match updatedMatch = match.copyWith(
        opponentScore: player.id == match.opponent.id ? match.opponentScore + 1 : match.opponentScore,
        userScore: player.id == match.user.id ? match.userScore + 1: match.userScore
    );
    // call repo and update game
    return updatedMatch;
  }
  
}