import 'package:congrega/features/lifecounter/data/PlayerRepository.dart';
import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:congrega/match/MatchBloc.dart';
import 'package:congrega/match/MatchState.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/features/lifecounter/timeWidgets/presentation/bloc/TimeSettingsBloc.dart';
import 'package:congrega/theme/CongregaTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'bloc/GameBloc.dart';
import 'bloc/GameEvents.dart';
import 'bloc/GameState.dart';
import 'widgets/LifeCounterStatusBar.dart';

class LifeCounterPage extends StatelessWidget {

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LifeCounterPage(
        playerRepository: KiwiContainer().resolve<PlayerRepository>()),
    );
  }

  LifeCounterPage({required this.playerRepository}) : super();

  final PlayerRepository playerRepository;

  Future<MatchState> createInitialMatchState() async {
    return new MatchState(
      status: MatchStatus.inProgress,
      user: await playerRepository.getAuthenticatedPlayer(),
      opponent: playerRepository.genericOpponent(),
    );
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
                        create: (BuildContext context) => MatchBloc(
                            initialState: snapshot.data
                        ),
                      ),
                      BlocProvider<GameBloc>(
                        create: (BuildContext context) => KiwiContainer().resolve<GameBloc>(),
                      ),
                      BlocProvider<TimeSettingsBloc>(
                        create: (BuildContext context) => TimeSettingsBloc(),
                      )
                    ],
                    child: Column(
                      children: [

                        // OPPONENT BAR
                        Expanded( flex: 45,
                            child:  Container( // opponent
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 20,
                                    child: Container(
                                      child: Center(
                                          child: Text(snapshot.data!.opponent.username.isNotEmpty ? snapshot.data!.opponent.username : AppLocalizations.of(context)!.opponent,
                                            style: TextStyle(fontSize: 20, color: Colors.white),)
                                      ),
                                      color: CongregaTheme.accentColor,
                                    ),
                                  ),


                                  // SEZIONE PUNTEGGIO AVVERSARIO
                                  Expanded(
                                    flex: 80,
                                    child: Transform.rotate(
                                        angle: 3.14,
                                        child: OpponentPointsWidget()
                                    ),
                                  ),
                                ],
                              ),
                            )),

                        // STATUS BAR
                        Expanded( flex: 10,
                            child:  StatusBar()),

                        // PLAYER BAR
                        Expanded( flex: 45,
                          child: PlayerPointsWidget(),
                        ),
                      ],
                    ),
                  );

                return Text("Error");
                }
            )));
  }

}

class OpponentPointsWidget extends StatelessWidget {
  const OpponentPointsWidget() : super();

  @override
  Widget build(BuildContext context) {
    // Column is rebuilt whenever the points list change its size
    return Container(
        child: BlocBuilder<GameBloc, GameState>(
            buildWhen: (previous, current) =>
            previous.opponent.points != current.opponent.points,
            builder: (context, state) {
              return Column(
                children: getPointRows(context, state.opponent.points),
              );
            }
        )
    );
  }

  List<Widget> getPointRows(BuildContext context, Set<PlayerPoints> pointList){
    return new List.generate(pointList.length, (int index){
      return new Expanded(
          flex: index==0 ? mainFlex(pointList.length) : secondaryFlex(pointList.length),
          child: OpponentPointRow(pointsData: pointList.elementAt(index))
      );
    });
  }

  int mainFlex(int count){
    switch(count) {
      case 1: return 100;
      case 2: return 60;
      case 3: return 40;
      case 4: return 30;
      case 5: return 20;
    }
    throw Exception("Too many counters");
  }

  int secondaryFlex(int count){
    switch(count) {
      case 2: return 40;
      case 3: return 30;
      case 4: return 23;
      case 5: return 20;
    }
    throw Exception("Too many counters");
  }

}

class OpponentPointRow extends StatelessWidget {
  const OpponentPointRow({required this.pointsData}) : super();

  final PlayerPoints pointsData;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          return Row(
            children: [
              Expanded(
                  flex: 40,
                  child: GestureDetector(
                      onTap: () => context.read<GameBloc>().add(
                          GamePlayerPointsChanged(state.opponent,
                              pointsData.copyWith(pointsData.value - 1))),
                      child: Container(
                        color: Colors.grey,
                        child: Center(
                          child: Icon(Icons.remove, size: 20,),
                        ),
                      )
                  )
              ),

              Expanded(
                flex: 20,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: Text(pointsData.value.toString(), style: TextStyle(fontSize: 30))),
                    const Padding(padding: EdgeInsets.all(2)),
                    Center(child: Icon(getIconForPoints(pointsData), size: 20,),)
                  ],
                ),
              ),

              Expanded(
                flex: 40,
                child: GestureDetector(
                    onTap: () => context.read<GameBloc>().add(
                        GamePlayerPointsChanged(state.opponent,
                            pointsData.copyWith(pointsData.value + 1))),
                    child: Container(
                      color: Colors.grey,
                      child: Center(
                        child: Icon(Icons.add, size: 20,),
                      ),
                    )
                ),
              ),
            ],
          );
        }
    );
  }

  IconData getIconForPoints(PlayerPoints points) {
    if (points is LifePoints) {
      return Icons.favorite;
    } else if (points is VenomPoints) {
      return Icons.visibility;
    } else if (points is EnergyPoints) {
      return Icons.flash_on;
    }

    return Icons.whatshot;
  }
}

class PlayerPointsWidget extends StatelessWidget {
  const PlayerPointsWidget() : super();

  @override
  Widget build(BuildContext context) {

    // Column is rebuilt whenever the points list change its size
    return Container(
        child: BlocBuilder<GameBloc, GameState>(
            buildWhen: (previous, current) =>
            previous.user.points != current.user.points,
            builder: (context, state) {
              return Column(
                children: getPointRows(context, state.user.points),
              );
            }
        )
    );
  }

  List<Widget> getPointRows(BuildContext context, Set<PlayerPoints> pointList){
    return new List.generate(pointList.length, (int index){
      return new Expanded(
          flex: index==0 ? mainFlex(pointList.length) : secondaryFlex(pointList.length),
          child: PointRow(pointsData: pointList.elementAt(index))
      );
    });
  }

  int mainFlex(int count){
    switch(count) {
      case 1: return 100;
      case 2: return 60;
      case 3: return 40;
      case 4: return 30;
      case 5: return 20;
    }
    throw Exception("Too many counters");
  }

  int secondaryFlex(int count){
    switch(count) {
      case 2: return 40;
      case 3: return 30;
      case 4: return 23;
      case 5: return 20;
    }
    throw Exception("Too many counters");
  }
}

class PointRow extends StatelessWidget {
  const PointRow({required this.pointsData}) : super();

  final PlayerPoints pointsData;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          return Row(
            children: [
              Expanded(
                  flex: 40,
                  child: GestureDetector(
                      onTap: () => context.read<GameBloc>().add(
                          GamePlayerPointsChanged(state.user,
                              pointsData.copyWith(pointsData.value - 1))),
                      child: Container(
                        color: Colors.grey,
                        child: Center(
                          child: Icon(Icons.remove, size: 20,),
                        ),
                      )
                  )
              ),

              Expanded(
                flex: 20,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: Text(pointsData.value.toString(), style: TextStyle(fontSize: 30))),
                    const Padding(padding: EdgeInsets.all(2)),
                    Center(child: Icon(getIconForPoints(pointsData), size: 20,),)
                  ],
                ),
              ),

              Expanded(
                flex: 40,
                child: GestureDetector(
                    onTap: () => context.read<GameBloc>().add(
                        GamePlayerPointsChanged(state.user,
                            pointsData.copyWith(pointsData.value + 1))),
                    child: Container(
                      color: Colors.grey,
                      child: Center(
                        child: Icon(Icons.add, size: 20,),
                      ),
                    )
                ),
              ),
            ],
          );
        }
    );
  }

  IconData getIconForPoints(PlayerPoints points) {
    if (points is LifePoints) {
      return Icons.favorite;
    } else if (points is VenomPoints) {
      return Icons.visibility;
    } else if (points is EnergyPoints) {
      return Icons.flash_on;
    }

    return Icons.whatshot;
  }
}