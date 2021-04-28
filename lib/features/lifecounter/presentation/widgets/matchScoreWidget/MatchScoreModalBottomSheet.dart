import 'package:congrega/features/dashboard/presentation/HomePage.dart';
import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/match/MatchBloc.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/match/MatchEvents.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/match/MatchState.dart';
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
                  buildWhen: (previous, current) => previous.match.userScore != current.match.userScore
                      || previous.match.opponentScore != current.match.opponentScore,
                  builder: (context, state) {

                    return Column(
                      children: [

                        Row(
                          children: [
                            PlayerScoreWidget(
                              playerUsername: "You",
                              playerScore: state.match.userScore,
                              callback: () => context.read<MatchBloc>()
                                  .add(MatchPlayerWinsGame(state.user)),
                            ),
                            PlayerScoreWidget(
                                playerUsername: state.opponentUsername,
                                playerScore:state.match.opponentScore,
                                callback: () => context.read<MatchBloc>()
                                    .add(MatchPlayerWinsGame(state.opponent))
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
                      child: ElevatedButton(
                        style: elevatedDangerButtonStyle,
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
                      child: ElevatedButton(
                        style: elevatedDangerButtonStyle,
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
                      child: ElevatedButton(
                        //color: Colors.redAccent,
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
    required this.playerUsername,
    required this.playerScore,
    this.callback,
  });

  final String playerUsername;
  final int playerScore;
  final Function()? callback;

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

final ButtonStyle elevatedDangerButtonStyle = ButtonStyle(backgroundColor: elevatedButtonDangerStyle);

final MaterialStateProperty<Color> elevatedButtonDangerStyle = MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed))
      return Colors.red.withOpacity(0.5);
    return Colors.red; // Use the component's default.
  },
);

class LeaveMatchDialog extends StatelessWidget {
  const LeaveMatchDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Leave match?"),
      content: Text("Leaving the match will result as a total resign."),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("CANCEL")
        ),
        ElevatedButton(
          child: Text("LEAVE"),
          style: ButtonStyle(backgroundColor: elevatedButtonDangerStyle),
          onPressed: () {
            Player user = context.read<MatchBloc>().state.match.user;
            context.read<MatchBloc>().add(
                PlayerLeavesMatch(user));
            if(context.read<MatchBloc>().isAnOfflineMatch()) {
              Navigator.of(context).pushAndRemoveUntil<void>(
                  HomePage.route(), (route) => false);
            } else {
              throw Exception("Online match?");
            }
          },
        ),
      ],
    );
  }
}

class SurrenderGameDialog extends StatelessWidget {
  const SurrenderGameDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Surrender game"),
      content: Text("Are you sure?"),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("CANCEL")
        ),
        ElevatedButton(
          child: Text("SURRENDER"),
          style: ButtonStyle(backgroundColor: elevatedButtonDangerStyle),
          onPressed: () {
            context.read<MatchBloc>().add(PlayerQuitsGame(context.read<MatchBloc>().state.user));
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
