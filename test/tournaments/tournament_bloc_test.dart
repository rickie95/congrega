
import 'package:bloc_test/bloc_test.dart';
import 'package:congrega/features/tournaments/data/TournamentController.dart';
import 'package:congrega/features/tournaments/model/Tournament.dart';
import 'package:congrega/features/tournaments/presentation/bloc/TournamentBloc.dart';
import 'package:congrega/features/tournaments/presentation/bloc/TournamentEvent.dart';
import 'package:congrega/features/tournaments/presentation/bloc/TournamentState.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockTournamentController extends Mock implements TournamentController {}

void main() {

  group('TournamentBloc', () {

    test('initial state is TournamentBloc.unknown', () {
      final tournamentBloc = TournamentBloc(controller: MockTournamentController());
      expect(tournamentBloc.state, const TournamentState.unknown());
      tournamentBloc.close();
    });
  });

  blocTest<TournamentBloc, TournamentState>(
      'emits [status: inProgress] when added RoundIsAvailable',
      build: () =>  TournamentBloc(controller: MockTournamentController()),
      act: (bloc) => bloc.add(const RoundIsAvailable()),
      expect: () => [TournamentState(
          enrolled: false,
          status: TournamentStatus.IN_PROGRESS,
          round: 0,
          tournament: Tournament.empty
      )]
  );

  blocTest<TournamentBloc, TournamentState>(
      'emits [tournament] when SetTournament is added',
      build: () =>  TournamentBloc(controller: MockTournamentController()),
      act: (bloc) => bloc.add(SetTournament(Tournament(
          id: '45',
          round: 0,
          status: TournamentStatus.UNKNOWN,
          judgeList: {},
          adminList: {},
          playerList: {},
          startingTime: null,
          type: "Limited",
          name: "foo"
      ))),
      expect: () => const <TournamentState>[TournamentState(
        tournament: Tournament(
            id: '45',
            round: 0,
            status: TournamentStatus.UNKNOWN,
            judgeList: {},
            adminList: {},
            playerList: {},
            startingTime: null,
            type: "Limited",
            name: "foo"
        ),
        status: TournamentStatus.UNKNOWN,
        round: 0,
        enrolled: false,
      )]
  );

  blocTest<TournamentBloc, TournamentState>(
      'emits [newTournament] when SetTournament is added after a [tournamentIsPresent]',
      build: () =>  TournamentBloc(controller: MockTournamentController()),
      act: (bloc) {
        bloc.add(
            SetTournament(
                Tournament(
                    id: '45',
                    round: 0,
                    status: TournamentStatus.UNKNOWN,
                    judgeList: {},
                    adminList: {},
                    playerList: {},
                    startingTime: null,
                    type: "Limited",
                    name: "foo"
                )
            )
        );
        bloc.add(
            SetTournament(
                Tournament(
                    id: '54',
                    round: 0,
                    status: TournamentStatus.UNKNOWN,
                    judgeList: {},
                    adminList: {},
                    playerList: {},
                    startingTime: null,
                    type: "Limited",
                    name: "bar"
                )
            )
        );
      },
      skip: 1,
      expect: () => const <TournamentState>[TournamentState(
        tournament: Tournament(
            id: '54',
            round: 0,
            status: TournamentStatus.UNKNOWN,
            judgeList: {},
            adminList: {},
            playerList: {},
            startingTime: null,
            type: "Limited",
            name: "bar"
        ),
        status: TournamentStatus.UNKNOWN,
        round: 0,
        enrolled: false,
      )]
  );
}