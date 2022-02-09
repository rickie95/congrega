import 'package:congrega/features/exceptions/HttpExceptions.dart';
import 'package:congrega/features/tournaments/data/TournamentController.dart';
import 'package:congrega/features/tournaments/model/Tournament.dart';
import 'package:congrega/features/tournaments/presentation/tournamentStatusPage/TournamentEventDetailsView.dart';
import 'package:congrega/features/tournaments/presentation/tournamentStatusPage/TournamentStatusPage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kiwi/kiwi.dart';

import 'DashboardWideTile.dart';

class EventsWidget extends StatelessWidget {
  const EventsWidget();

  @override
  Widget build(BuildContext context) {
    return DashboardWideTile(
        title: AppLocalizations.of(context)!.events_widget_title,
        child: Container(
          child: _body(context),
        ));
  }

  Widget _body(BuildContext context) {
    return FutureBuilder(
      future: KiwiContainer().resolve<TournamentController>().getEventList(),
      builder: (BuildContext context, AsyncSnapshot<List<Tournament>> snapshot) {
        if (snapshot.hasData)
          return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _getEventListButtons(context, snapshot.data!));

        if (snapshot.hasError) return _buildErrorWidget(snapshot.error);

        return Column(children: [
          SizedBox(
            child: CircularProgressIndicator(),
            width: 60,
            height: 60,
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text("Loading"),
          )
        ]);
      },
    );
  }

  List<Widget> _getEventListButtons(BuildContext context, List<Tournament> eventList) {
    List<Tournament> tournamentList = eventList.length > 3 ? eventList.sublist(0, 3) : eventList;
    return new List.generate(
        tournamentList.length,
        (index) => ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).push(TournamentStatusPage.route(tournamentList[index])),
              child: Text(tournamentList[index].name),
            ));
  }

  Widget _buildErrorWidget(Object? error) {
    String errorMessage = "Couldn't fetch event list.";

    if (error is ConnectionException)
      errorMessage = "Cannot reach server. Check your connection or try again later.";

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_off_outlined,
                size: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
