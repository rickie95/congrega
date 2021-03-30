import 'package:congrega/features/authentication/AuthenticationBloc.dart';
import 'package:congrega/features/tournaments/presentation/bloc/TournamentBloc.dart';
import 'package:congrega/features/tournaments/presentation/bloc/TournamentEvent.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class ConfirmJoiningEventDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("Joining event"),
        content: SingleChildScrollView(
            child: ListBody(
                children: <Widget>[
                  Text("Do you want to join the event? You will be listed among the participants.")
                ]
            )
        ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("CANCEL")),
        ElevatedButton(onPressed: () {
          context.read<TournamentBloc>().add(
              EnrollingInTournament(
                  BlocProvider.of<AuthenticationBloc>(context).state.user
              )
          );
          Navigator.of(context).pop();
        }, child: Text("JOIN"),)
      ],
    );
  }
}