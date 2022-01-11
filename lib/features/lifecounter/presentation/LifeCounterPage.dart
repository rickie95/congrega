import 'package:congrega/features/dashboard/presentation/HomePage.dart';
import 'package:congrega/features/lifecounter/data/game/game_live_manager.dart';
import 'package:congrega/features/lifecounter/model/Match.dart';
import 'package:congrega/features/lifecounter/model/PlayerPoints.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/match/MatchEvents.dart';
import 'package:congrega/features/lifecounter/presentation/widgets/LifeCounterModalBottomSheet.dart';
import 'package:congrega/features/lifecounter/presentation/widgets/PlayerPointsWidget.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/match/MatchBloc.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/match/MatchState.dart';
import 'package:congrega/features/lifecounter/presentation/widgets/timeWidgets/bloc/TimeSettingsBloc.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/features/users/UserRepository.dart';
import 'package:congrega/features/websocket/invitation_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';

import 'bloc/LifeCounterBloc.dart';
import 'bloc/LifeCounterEvents.dart';
import 'bloc/LifeCounterState.dart';
import 'widgets/LifeCounterStatusBar.dart';

class LifeCounterPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LifeCounterPage());
  }

  LifeCounterPage() : super();

  Future<MatchState> createInitialMatchState() async {
    return new MatchState.unknown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: FutureBuilder(
                future: createInitialMatchState(),
                builder: (BuildContext context, AsyncSnapshot<MatchState> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: Text("Just a sec bro"));

                  if (snapshot.hasData && snapshot.data != null)
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider<MatchBloc>(
                          create: (BuildContext context) => KiwiContainer().resolve<MatchBloc>(),
                        ),
                        BlocProvider<LifeCounterBloc>(
                          create: (BuildContext context) =>
                              KiwiContainer().resolve<LifeCounterBloc>(),
                        ),
                        BlocProvider<TimeSettingsBloc>(
                          create: (BuildContext context) => TimeSettingsBloc(),
                        )
                      ],
                      child: FutureBuilder(
                          future: KiwiContainer().resolve<UserRepository>().getUser(),
                          builder: (context, AsyncSnapshot<User> userSnapshot) {
                            if (userSnapshot.hasData && userSnapshot.data != null) {
                              User user = userSnapshot.data!;
                              return Column(
                                children: [
                                  // OPPONENT BAR
                                  Expanded(
                                      flex: 46,
                                      child: Container(
                                        // opponent
                                        child: Column(
                                          children: [
                                            // SEZIONE PUNTEGGIO AVVERSARIO
                                            Expanded(
                                              flex: 100,
                                              child: BlocBuilder<MatchBloc, MatchState>(
                                                builder: (context, matchState) {
                                                  KiwiContainer()
                                                      .resolve<GameLiveManager>()
                                                      .setOnLifePointsUpdateCallback(
                                                        (int updatedLifePoints) => KiwiContainer()
                                                            .resolve<LifeCounterBloc>()
                                                            .add(
                                                              GamePlayerPointsChanged(
                                                                matchState.opponent(user),
                                                                LifePoints(updatedLifePoints),
                                                              ),
                                                            ),
                                                      );

                                                  KiwiContainer()
                                                      .resolve<InvitationManager>()
                                                      .setOnMessageCallback((message) {
                                                    if (message.type == MessageType.GAME) {
                                                      KiwiContainer().resolve<MatchBloc>().add(
                                                          PlayerQuitsGame(
                                                              matchState.opponent(user)));
                                                      KiwiContainer()
                                                          .resolve<LifeCounterBloc>()
                                                          .add(ResetGame());
                                                    } else if (message.type == MessageType.MATCH &&
                                                        message.data == "END") {
                                                      KiwiContainer().resolve<MatchBloc>().add(
                                                            PlayerLeavesMatch(
                                                              matchState.opponent(user),
                                                            ),
                                                          );
                                                      showDialog(
                                                          context: context,
                                                          builder: (contex) => AlertDialog(
                                                                title: Text("You've won!"),
                                                                content: Text(
                                                                    "Your opponent resigned, congratulations for your victory!"),
                                                                actions: [
                                                                  ElevatedButton(
                                                                      onPressed: () => Navigator.of(
                                                                              context)
                                                                          .pushAndRemoveUntil<void>(
                                                                              HomePage.route(),
                                                                              (route) => false),
                                                                      child: Text("OK")),
                                                                ],
                                                              ));
                                                    }
                                                  });

                                                  return Transform.rotate(
                                                    angle:
                                                        matchState.match.type == MatchType.offline
                                                            ? 3.14
                                                            : 0,
                                                    child: PlayerPointsWidget(
                                                      pointSectionBlocBuilder: BlocBuilder<
                                                              LifeCounterBloc, LifeCounterState>(
                                                          buildWhen: (previous, current) =>
                                                              previous.opponentOf(user).points !=
                                                              current.opponentOf(user).points,
                                                          builder: (context, state) {
                                                            return Column(
                                                              children: getPointRows(
                                                                  context, state.opponentOf(user),
                                                                  enabled: matchState.match.type ==
                                                                      MatchType.offline),
                                                            );
                                                          }),
                                                      settingsBlocBuilder: matchState.match.type ==
                                                              MatchType.offline
                                                          ? BlocBuilder<LifeCounterBloc,
                                                              LifeCounterState>(
                                                              buildWhen: (previous, current) =>
                                                                  (previous
                                                                          .opponentOf(user)
                                                                          .points !=
                                                                      current
                                                                          .opponentOf(user)
                                                                          .points),
                                                              builder: (context, state) =>
                                                                  PlayerCountersSettings(
                                                                      player:
                                                                          state.opponentOf(user)),
                                                            )
                                                          : null,
                                                      backgroundColor: Colors.deepPurple,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),

                                  // STATUS BAR
                                  Expanded(flex: 8, child: StatusBar()),

                                  // PLAYER BAR
                                  Expanded(
                                    flex: 46,
                                    child: PlayerPointsWidget(
                                      pointSectionBlocBuilder:
                                          BlocBuilder<LifeCounterBloc, LifeCounterState>(
                                              buildWhen: (previous, current) =>
                                                  previous.getUser(user).points !=
                                                  current.getUser(user).points,
                                              builder: (context, state) {
                                                return Column(
                                                  children:
                                                      getPointRows(context, state.getUser(user)),
                                                );
                                              }),
                                      settingsBlocBuilder:
                                          BlocBuilder<LifeCounterBloc, LifeCounterState>(
                                              buildWhen: (previous, current) =>
                                                  (previous.getUser(user).points !=
                                                      current.getUser(user).points),
                                              builder: (context, state) => PlayerCountersSettings(
                                                  player: state.getUser(user))),
                                      backgroundColor: Colors.orange,
                                    ),
                                  ),
                                ],
                              );
                            }

                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }),
                    );

                  return Center(child: Text("Error"));
                })));
  }
}
