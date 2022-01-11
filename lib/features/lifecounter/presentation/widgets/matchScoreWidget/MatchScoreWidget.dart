import 'package:congrega/features/lifecounter/presentation/bloc/match/MatchBloc.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/match/MatchState.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/features/users/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';

class MatchScoreWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchBloc, MatchState>(
        buildWhen: (previous, current) =>
            previous.match.playerOneScore != current.match.playerOneScore ||
            previous.match.playerTwoScore != current.match.playerTwoScore,
        builder: (context, state) => FutureBuilder<User>(
              future: KiwiContainer().resolve<UserRepository>().getUser(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null)
                  return Text(
                    "${state.userScore(snapshot.data!)} - ${state.opponentScore(snapshot.data!)}",
                    style: TextStyle(fontSize: 30),
                  );

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ));
  }
}
