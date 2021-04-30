import 'package:animations/animations.dart';
import 'package:congrega/features/tournaments/presentation/tournamentStatusPage/TournamentStatusPage.dart';
import 'package:congrega/features/drawer/CongregaDrawer.dart';
import 'package:congrega/features/tournaments/data/TournamentController.dart';
import 'package:congrega/features/tournaments/model/Tournament.dart';
import 'package:congrega/features/tournaments/data/repositories/TournamentRepository.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'JoinByCodeDialog.dart';

class TournamentPage extends StatelessWidget{

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => TournamentPage(
        new TournamentController(repository: new TournamentRepository())));
  }

  TournamentPage(TournamentController controller) : _tournamentController = controller;

  final TournamentController _tournamentController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.events_page_title),
          actions: [
            IconButton(icon: Icon(Icons.search), onPressed: () => {}),
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry>[
                  new PopupMenuItem( child: Text(AppLocalizations.of(context)!.events_action_create)),
                  new PopupMenuItem( child: Text(AppLocalizations.of(context)!.events_action_search)),
                ];
              },
            ),
          ],
        ),
        drawer: CongregaDrawer(),
        floatingActionButton: FloatingActionButton.extended(
          label: Text(AppLocalizations.of(context)!.events_join_by_code.toString().toUpperCase()),
          onPressed: () => _showJoinByCodeDialog(context),
        ),
        body: _eventList(context)
    );
  }

  Widget _eventRow(BuildContext context, Tournament tournament) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      openBuilder: (BuildContext _, VoidCallback openContainer) => TournamentStatusPage(tournament),
      closedBuilder: (BuildContext _, VoidCallback openContainer) => ListTile(
        onTap: openContainer,
        leading: CircleAvatar(child: Text(tournament.name[0])),
        title: Text(tournament.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        subtitle: Text(tournament.type),
      ),
    );
  }

  Widget _eventList(BuildContext context){
    List<Tournament> eventList = _tournamentController.getEventList();
    List<Tournament> participatedList = _tournamentController.getParticipatedEvents();
    List<Tournament> createdList = _tournamentController.getCreatedEvents();


    return ListView(
        children: [

          Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(AppLocalizations.of(context)!.events_inProgress_label.toString().toUpperCase(), style: TextStyle(fontSize: 15, color: Color.fromRGBO(0, 0, 0, 0.54)),)
          ),
          ...new List.generate(participatedList.length,
                  (index) => _eventRow(context, participatedList.elementAt(index))),
          Divider(),

          Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(AppLocalizations.of(context)!.events_myevents_label.toString().toUpperCase(),
                style: TextStyle(fontSize: 15, color: Color.fromRGBO(0, 0, 0, 0.54)),)
          ),
          ...new List.generate(createdList.length,
                  (index) => _eventRow(context, createdList.elementAt(index))),
          Divider(),

          Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(AppLocalizations.of(context)!.events_nearby_label.toString().toUpperCase(),
                style: TextStyle(fontSize: 15, color: Color.fromRGBO(0, 0, 0, 0.54)),)
          ),
          ...new List.generate(eventList.length,
                  (index) => _eventRow(context, eventList.elementAt(index)))
        ]
    );
  }

  Future<void> _showJoinByCodeDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return JoinByCodeDialog();
      },
    );
  }

}
