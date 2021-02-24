import 'package:congrega/pages/CongregaDrawer.dart';
import 'package:congrega/theme/CongregaTheme.dart';
import 'package:congrega/tournament/controller/TournamentController.dart';
import 'package:congrega/tournament/model/Tournament.dart';
import 'package:congrega/tournament/repository/TournamentRepository.dart';
import 'package:congrega/tournament/views/tournamentStatusPage/TournamentStatusPage.dart';
import 'package:flutter/material.dart';

import 'JoinByCodeDialog.dart';

class TournamentPage extends StatelessWidget{

  static const String pageTitle = "Tournaments";

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => TournamentPage(
        new TournamentController(repo: new TournamentRepository())));
  }

  TournamentPage(TournamentController controller) : _tournamentController = controller;

  final TournamentController _tournamentController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text(pageTitle),
          actions: [
            IconButton(icon: Icon(Icons.search), onPressed: () => {}),
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry>[
                  new PopupMenuItem( child: Text("Create new event")),
                  new PopupMenuItem( child: Text("Search")),
                ];
              },
            ),
          ],
        ),
        drawer: CongregaDrawer(),
        floatingActionButton: FloatingActionButton.extended(
          label: Text("JOIN BY CODE"),
          onPressed: () => _showJoinByCodeDialog(context),
        ),
        body: _eventList(context)
    );
  }

  Widget _eventRow(BuildContext context, Tournament tournament) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(TournamentStatusPage.route(tournament)),
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Row(
              children: [
                Expanded(
                  flex: 12,
                  child: CircleAvatar(
                    child: Text(tournament.name[0]),
                  ),
                ),
                Expanded(
                  flex: 78,
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tournament.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        Text(tournament.type)
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 10,
                    child: Icon(Icons.arrow_forward_ios_rounded)
                )
              ]
          )
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
              child: Text("IN PROGRESS", style: TextStyle(fontSize: 15, color: Color.fromRGBO(0, 0, 0, 0.54)),)
          ),
          ...new List.generate(participatedList.length,
                  (index) => _eventRow(context, participatedList.elementAt(index))),
          Divider(),

          Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text("MY EVENTS", style: TextStyle(fontSize: 15, color: Color.fromRGBO(0, 0, 0, 0.54)),)
          ),
          ...new List.generate(createdList.length,
                  (index) => _eventRow(context, createdList.elementAt(index))),
          Divider(),

          Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text("NEARBY", style: TextStyle(fontSize: 15, color: Color.fromRGBO(0, 0, 0, 0.54)),)
          ),
          ...new List.generate(eventList.length,
                  (index) => _eventRow(context, eventList.elementAt(index)))
        ]
    );
  }


  Widget _noTournamentAvailableContainer(BuildContext context) {
    return Center(
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: CongregaTheme.primaryColor,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text("You're not enrolled in any event yet",
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),

            RaisedButton(child: Text("CREATE NEW EVENT"), onPressed: () {}),
            RaisedButton(child: Text("SEARCH FOR EVENTS"), onPressed: () {})
          ],
        ),
      ),
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
