import 'package:congrega/authentication/AuthenticationBloc.dart';
import 'package:congrega/features/tournaments/presentation/bloc/TournamentBloc.dart';
import 'package:congrega/features/tournaments/presentation/bloc/TournamentEvent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmLeavingEventDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Leaving event"),
      content: SingleChildScrollView(
          child: ListBody(
              children: <Widget>[
                Text("Do you really want to leave the event? You will be removed from the players.")
              ]
          )
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("CANCEL")),
        RaisedButton(
          color: Colors.redAccent,
          onPressed: () {
          context.read<TournamentBloc>().add(
              AbandoningTournament(
                  BlocProvider.of<AuthenticationBloc>(context).state.user!
              )
          );
          Navigator.of(context).pop();
        }, child: Text("LEAVE"),)
      ],
    );
  }
}