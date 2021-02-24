import 'package:congrega/tournament/controller/TournamentController.dart';
import 'package:congrega/tournament/model/Tournament.dart';
import 'package:congrega/tournament/repository/TournamentRepository.dart';
import 'package:flutter/material.dart';

import 'DashboardWideTile.dart';

class EventsWidget extends StatelessWidget {
  const EventsWidget({
    Key key,
  }) : super(key: key);

  Widget _body(BuildContext context){
    return Column (
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _getEventListButtons(context)
    );
  }

  List<Widget> _getEventListButtons(BuildContext context){
    TournamentController tournamentController = TournamentController.getInstance();
    List<Tournament> tournamentList = tournamentController.getEventList().sublist(0, 3);
    return new List.generate(tournamentList.length, (index) => RaisedButton(
      onPressed: () {},
      child: Text(tournamentList[index].name),
    )
    );
  }

  @override
  Widget build(BuildContext context) {
    return DashboardWideTile(
        title: 'Events',
        child: Container(
          child: _body(context),
        )
    );
  }
}