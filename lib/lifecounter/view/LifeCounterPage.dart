import 'package:congrega/lifecounter/GameBloc.dart';
import 'package:congrega/lifecounter/GameEvents.dart';
import 'package:congrega/lifecounter/GameState.dart';
import 'package:congrega/lifecounter/model/Player.dart';
import 'package:congrega/lifecounter/view/LifeCounterStatusBar.dart';
import 'package:congrega/match/MatchBloc.dart';
import 'package:congrega/match/MatchState.dart';
import 'package:congrega/model/User.dart';
import 'package:congrega/settings/TimeSettingsBloc.dart';
import 'package:congrega/theme/CongregaTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LifeCounterPage extends StatelessWidget {

  static Route route({User opponent}) {
    return MaterialPageRoute<void>(builder: (_) => LifeCounterPage(opponent: opponent));
  }
  
  LifeCounterPage({this.opponent}) : super();
  
  final User opponent;

  GameState createInitialGameState(){
    final playerOneId = new BigInt.from(1);
    final Set<PlayerPoints> playerOnePoints = { new LifePoints(20)};
    final playerTwoId = new BigInt.from(2);

    final Player playerOne = Player(id: playerOneId, points: playerOnePoints, username: "MagicMike");
    final Player playerTwo = Player(
        id: opponent != null ? opponent.id : playerTwoId,
        points: playerOnePoints,
        username: opponent != null ? opponent.username : "Opponent"
    );

    final GameState initialGameState = new GameState(
      status: GameStatus.unknown,
      user: playerOne,
      opponent: playerTwo,
    );

    return initialGameState;
  }

  MatchState createInitialMatchState() {
    final playerOneId = new BigInt.from(1);
    final Set<PlayerPoints> playerOnePoints = { new LifePoints(20)};
    final playerTwoId = new BigInt.from(2);


    final Player playerOne = Player(id: playerOneId, points: playerOnePoints, username: "MagicMike");
    final Player playerTwo = Player(
        id: opponent != null ? opponent.id : playerTwoId,
        points: playerOnePoints,
        username: opponent != null ? opponent.username : "Opponent"
    );

    return new MatchState(
        status: MatchStatus.inProgress,
        user: playerOne,
        opponent: playerTwo,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Builder(
                builder: (context) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider<MatchBloc>(
                        create: (BuildContext context) => MatchBloc(
                            initialState: createInitialMatchState()
                        ),
                      ),
                      BlocProvider<GameBloc>(
                        create: (BuildContext context) => GameBloc(
                            RepositoryProvider.of(context),
                            state: createInitialGameState()
                        ),
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
                                          child: Text(opponent != null ? opponent.username : "Opponent",
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
                }
            )));
  }

}

class OpponentPointsWidget extends StatelessWidget {
  const OpponentPointsWidget({
    Key key,
  }) : super(key: key);

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
    return null;
  }

  int secondaryFlex(int count){
    switch(count) {
      case 2: return 40;
      case 3: return 30;
      case 4: return 23;
      case 5: return 20;
    }

    return null;
  }

}

class OpponentPointRow extends StatelessWidget {
  const OpponentPointRow({
    Key key, this.pointsData
  }) : super(key: key);

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
  const PlayerPointsWidget({
    Key key,
  }) : super(key: key);

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
    return null;
  }

  int secondaryFlex(int count){
    switch(count) {
      case 2: return 40;
      case 3: return 30;
      case 4: return 23;
      case 5: return 20;
    }

    return null;
  }
}

class PointRow extends StatelessWidget {
  const PointRow({
    Key key, this.pointsData
  }) : super(key: key);

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