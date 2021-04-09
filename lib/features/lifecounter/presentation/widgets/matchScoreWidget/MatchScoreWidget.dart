import 'package:congrega/features/lifecounter/presentation/bloc/match/MatchBloc.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/match/MatchState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchScoreWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchBloc, MatchState>(
        buildWhen: (previous, current) =>
        previous.userScore != current.userScore || previous.opponentScore != current.opponentScore,
        builder: (context, state) {
          final String userScore = state.userScore.toString();
          final String opponentScore = state.opponentScore.toString();
          return Text("$userScore - $opponentScore", style: TextStyle(fontSize: 30),);
        }
    );
  }

}
