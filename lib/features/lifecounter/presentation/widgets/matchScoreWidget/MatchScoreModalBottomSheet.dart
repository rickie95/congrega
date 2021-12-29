import 'package:congrega/features/dashboard/presentation/HomePage.dart';
import 'package:congrega/features/lifecounter/model/Match.dart';
import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/match/MatchBloc.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/match/MatchEvents.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/match/MatchState.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/features/users/UserRepository.dart';
import 'package:congrega/ui/congrega_elevated_button_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kiwi/kiwi.dart';

class MatchScoreModalBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(shrinkWrap: true, scrollDirection: Axis.vertical, children: [
      Container(
          // TITLE
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child:
              Text("MATCH", style: TextStyle(fontSize: 16, color: Color.fromRGBO(0, 0, 0, 0.54)))),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Material(
          elevation: 14,
          shadowColor: Colors.grey,
          borderRadius: BorderRadius.circular(12.0),
          child: Center(
            child: Container(
              // MATCH STATUS
              padding: EdgeInsets.all(10),
              child: FutureBuilder(
                  future: KiwiContainer().resolve<UserRepository>().getUser(),
                  builder: (context, AsyncSnapshot<User> userSnapshot) =>
                      createWidget(userSnapshot)),
            ),
          ),
        ),
      ),
      Padding(padding: EdgeInsets.symmetric(vertical: 12)),
      ListTile(
        title: Text(AppLocalizations.of(context)!.leave_match_button_text),
        leading: Icon(Icons.exit_to_app),
        onTap: () => showDialog(
            context: context,
            builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<MatchBloc>(context),
                  child: LeaveMatchDialog(),
                )),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context)!.leave_game_button_text),
        leading: Icon(Icons.error),
        onTap: () => showDialog(
            context: context,
            builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<MatchBloc>(context),
                  child: SurrenderGameDialog(),
                )),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context)!.call_judge_button_text),
        leading: Icon(Icons.help),
        enabled: BlocProvider.of<MatchBloc>(context).state.match.type != MatchType.offline,
        onTap: () => showDialog(
            context: context,
            builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<MatchBloc>(context),
                  child: SurrenderGameDialog(),
                )),
      )
    ]);
  }

  Widget createWidget(AsyncSnapshot<User> userSnapshot) {
    if (userSnapshot.hasData && userSnapshot.data != null)
      return BlocBuilder<MatchBloc, MatchState>(
        buildWhen: (previous, current) =>
            previous.match.playerOneScore != current.match.playerOneScore ||
            previous.match.playerTwoScore != current.match.playerTwoScore,
        builder: (context, state) {
          return Column(
            children: [
              Row(
                children: [
                  PlayerScoreWidget(
                    playerUsername: "You",
                    playerScore: state.match.playerOneScore,
                    callback: () => context
                        .read<MatchBloc>()
                        .add(MatchPlayerWinsGame(state.user(userSnapshot.data!))), //FIXME
                  ),
                  PlayerScoreWidget(
                      playerUsername: state.opponentUsername,
                      playerScore: state.match.playerTwoScore,
                      callback: () => context
                          .read<MatchBloc>()
                          .add(MatchPlayerWinsGame(state.opponent(userSnapshot.data!)))),
                ],
              ),
            ],
          );
        },
      );

    return Center(
      child: CircularProgressIndicator(),
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
        child: callback != null
            ? GestureDetector(
                onTap: callback,
                child: _getUI(context),
              )
            : _getUI(context));
  }

  Widget _getUI(BuildContext context) {
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
  const LeaveMatchDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.leave_match_dialog_title),
      content: Text(AppLocalizations.of(context)!.leave_match_dialog_message),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
                AppLocalizations.of(context)!.dialog_cancel_button_text.toString().toUpperCase())),
        ElevatedButton(
          child: Text(AppLocalizations.of(context)!
              .leave_match_dialog_confirm_text
              .toString()
              .toUpperCase()),
          style: elevatedDangerButtonStyle,
          onPressed: () {
            Player user = context.read<MatchBloc>().state.match.playerOne;
            context.read<MatchBloc>().add(PlayerLeavesMatch(user));
            if (context.read<MatchBloc>().isAnOfflineMatch()) {
              Navigator.of(context).pushAndRemoveUntil<void>(HomePage.route(), (route) => false);
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
      title: Text(AppLocalizations.of(context)!.leave_game_dialog_title),
      content: Text(AppLocalizations.of(context)!.leave_game_dialog_message),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
                AppLocalizations.of(context)!.dialog_cancel_button_text.toString().toUpperCase())),
        ElevatedButton(
          child: Text(AppLocalizations.of(context)!
              .leave_game_dialog_confirm_text
              .toString()
              .toUpperCase()),
          style: ButtonStyle(backgroundColor: dangerButtonColorState),
          onPressed: () async {
            User user = await KiwiContainer().resolve<UserRepository>().getUser();
            context
                .read<MatchBloc>()
                .add(PlayerQuitsGame(context.read<MatchBloc>().state.user(user)));
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
