import 'package:congrega/features/tournaments/data/TournamentController.dart';
import 'package:congrega/features/tournaments/model/Tournament.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kiwi/kiwi.dart';

import 'DashboardWideTile.dart';

class EventsWidget extends StatelessWidget {
  const EventsWidget();

  Widget _body(BuildContext context){
    return Column (
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _getEventListButtons(context)
    );
  }

  List<Widget> _getEventListButtons(BuildContext context){
    TournamentController tournamentController = KiwiContainer().resolve<TournamentController>();
    List<Tournament> tournamentList = tournamentController.getEventList().sublist(0, 3);
    return new List.generate(tournamentList.length, (index) => ElevatedButton(
      onPressed: () {},
      child: Text(tournamentList[index].name),
    )
    );
  }

  @override
  Widget build(BuildContext context) {
    return DashboardWideTile(
        title: AppLocalizations.of(context)!.events_widget_title,
        child: Container(
          child: _body(context),
        )
    );
  }
}