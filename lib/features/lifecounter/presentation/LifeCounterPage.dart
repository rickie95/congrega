import 'package:congrega/features/lifecounter/presentation/widgets/LifeCounterModalBottomSheet.dart';
import 'package:congrega/features/lifecounter/presentation/widgets/PlayerPointsWidget.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/match/MatchBloc.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/match/MatchState.dart';
import 'package:congrega/features/lifecounter/presentation/widgets/timeWidgets/bloc/TimeSettingsBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';


import 'bloc/LifeCounterBloc.dart';
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
                  if(snapshot.connectionState == ConnectionState.waiting)
                    return Text("Just a sec bro");

                  if(snapshot.hasData && snapshot.data != null)
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider<MatchBloc>(
                          create: (BuildContext context) => KiwiContainer().resolve<MatchBloc>(),
                        ),
                        BlocProvider<LifeCounterBloc>(
                          create: (BuildContext context) => KiwiContainer().resolve<LifeCounterBloc>(),
                        ),
                        BlocProvider<TimeSettingsBloc>(
                          create: (BuildContext context) => TimeSettingsBloc(),
                        )
                      ],
                      child: Column(
                        children: [

                          // OPPONENT BAR
                          Expanded( flex: 46,
                              child:  Container( // opponent
                                child: Column(
                                  children: [
                                    // Expanded(
                                    //   flex: 20,
                                    //   child: Container(
                                    //     child: Center(
                                    //         child: Text(snapshot.data!.opponentUsername.isNotEmpty ? snapshot.data!.opponentUsername : AppLocalizations.of(context)!.opponent,
                                    //           style: TextStyle(fontSize: 20, color: Colors.white),)
                                    //     ),
                                    //     color: CongregaTheme.accentColor,
                                    //   ),
                                    // ),


                                    // SEZIONE PUNTEGGIO AVVERSARIO
                                    Expanded(
                                      flex: 100,
                                      child: Transform.rotate(
                                          angle: 3.14,
                                          child: PlayerPointsWidget(
                                            pointSectionBlocBuilder: BlocBuilder<LifeCounterBloc, LifeCounterState>(
                                                buildWhen: (previous, current) =>
                                                previous.opponent.points != current.opponent.points,
                                                builder: (context, state) {
                                                  return Column(
                                                    children: getPointRows(context, state.opponent),
                                                  );
                                                }
                                            ),
                                            settingsBlocBuilder: BlocBuilder<LifeCounterBloc, LifeCounterState>(
                                                buildWhen: (previous, current) => (previous.opponent.points != current.opponent.points),
                                                builder: (context, state) => PlayerCountersSettings(player: state.opponent)
                                            ),
                                            backgroundColor: Colors.deepPurple,
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                              )),

                          // STATUS BAR
                          Expanded( flex: 8,
                              child:  StatusBar()),

                          // PLAYER BAR
                          Expanded( flex: 46,
                            child: PlayerPointsWidget(
                              pointSectionBlocBuilder: BlocBuilder<LifeCounterBloc, LifeCounterState>(
                                  buildWhen: (previous, current) =>
                                  previous.user.points != current.user.points,
                                  builder: (context, state) {
                                    return Column(
                                      children: getPointRows(context, state.user),
                                    );
                                  }
                              ),
                              settingsBlocBuilder: BlocBuilder<LifeCounterBloc, LifeCounterState>(
                                  buildWhen: (previous, current) => (previous.user.points != current.user.points),
                                  builder: (context, state) => PlayerCountersSettings(player: state.user)
                              ),
                              backgroundColor: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    );

                  return Text("Error");
                }
            )));
  }
}