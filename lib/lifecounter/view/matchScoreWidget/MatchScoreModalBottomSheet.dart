import 'package:congrega/match/MatchBloc.dart';
import 'package:congrega/match/MatchEvents.dart';
import 'package:congrega/match/MatchState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchScoreModalBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container( // TITLE
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
              child: Text("Match", style: TextStyle(fontSize: 16, color: Color.fromRGBO(0, 0, 0, 0.54)))
          ),

          Material(
            elevation: 14,
            shadowColor: Colors.grey,
            borderRadius: BorderRadius.circular(12.0),
            child: Center(
              child: Container( // MATCH STATUS
                padding: EdgeInsets.all(10),
                child: BlocBuilder<MatchBloc, MatchState>(
                  builder: (context, state) {

                    return Column(
                      children: [

                        Row(
                          children: [
                            PlayerScoreWidget(
                              playerUsername: "You",
                              playerScore: state.userScore,
                              callback: () => context.read<MatchBloc>().add(MatchPlayerWinsGame(state.user)),
                            ),
                            PlayerScoreWidget(
                                playerUsername: state.opponent.username,
                                playerScore:state.opponentScore,
                                callback: () => context.read<MatchBloc>().add(MatchPlayerWinsGame(state.opponent))
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          Column(
              children: [
                Container( // TITLE
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                    child: Text("Danger zone", style: TextStyle(fontSize: 16, color: Color.fromRGBO(255, 0, 0, 0.54)))
                ),

                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      child: RaisedButton(
                        color: Colors.redAccent,
                        child: const Text("LEAVE MATCH"),
                        onPressed: () {
                          showDialog( context: context,
                              builder: (_) =>
                                  BlocProvider.value(
                                    value: BlocProvider.of<MatchBloc>(context),
                                    child: LeaveMatchDialog(),
                                  )
                          );
                        },

                      ),
                    ),
                    Container(

                      padding: EdgeInsets.all(4),
                      child: RaisedButton(
                        color: Colors.redAccent,
                        child: const Text("SURRENDER GAME"),
                        onPressed: () { showDialog(
                            context: context,
                            builder: (_) =>
                                BlocProvider.value(
                                  value: BlocProvider.of<MatchBloc>(context),
                                  child: SurrenderGameDialog(),
                                )
                        );
                        },
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Container(

                      padding: EdgeInsets.all(4),
                      child: RaisedButton(
                        color: Colors.redAccent,
                        child: const Text("CALL JUDGE"),
                        onPressed: () { showDialog(
                            context: context,
                            builder: (_) =>
                                BlocProvider.value(
                                  value: BlocProvider.of<MatchBloc>(context),
                                  child: SurrenderGameDialog(),
                                )
                        );
                        },
                      ),
                    ),
                  ],
                )

              ]
          )



        ],
      ),
    );
  }

}

class PlayerScoreWidget extends StatelessWidget {
  const PlayerScoreWidget({
    this.playerUsername,
    this.playerScore,
    this.callback,
    Key key,
  }) : super(key: key);

  final String playerUsername;
  final int playerScore;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 50,
        child: callback != null ? GestureDetector(
          onTap: callback,
          child: _getUI(context),
        ) : _getUI(context)
    );
  }

  Widget _getUI(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(playerUsername, style: TextStyle(fontSize: 20)),
        Text(playerScore.toString(), style: TextStyle(fontSize: 30)),
      ],
    );
  }
}

class LeaveMatchDialog extends StatelessWidget {
  const LeaveMatchDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Leave match?"),
      content: Text("Leaving the match will result as a total resign."),
      actions: [
        FlatButton(
            onPressed: (){ },
            child: Text("CANCEL")
        ),
        RaisedButton(
          child: Text("LEAVE"),
          color: Colors.redAccent,
          onPressed: () {
            context.read<MatchBloc>().add(
                MatchPlayerLeaveMatch(
                    context.read<MatchBloc>().state.user));
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class SurrenderGameDialog extends StatelessWidget {
  const SurrenderGameDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Surrender game"),
      content: Text("Are you sure?"),
      actions: [
        FlatButton(
            onPressed: (){ },
            child: Text("CANCEL")
        ),
        RaisedButton(
          child: Text("SURRENDER"),
          color: Colors.redAccent,
          onPressed: () {
            context.read<MatchBloc>().add(
                MatchPlayerQuitsGame(
                    context.read<MatchBloc>().state.user));
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
