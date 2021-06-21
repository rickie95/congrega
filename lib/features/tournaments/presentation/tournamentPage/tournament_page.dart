import 'package:animations/animations.dart';
import 'package:congrega/features/tournaments/presentation/bloc/TournamentBloc.dart';
import 'package:congrega/features/tournaments/presentation/bloc/TournamentEvent.dart';
import 'package:congrega/features/tournaments/presentation/tournamentPage/refresh_widget.dart';
import 'package:congrega/features/tournaments/presentation/tournamentStatusPage/TournamentStatusPage.dart';
import 'package:congrega/features/drawer/CongregaDrawer.dart';
import 'package:congrega/features/tournaments/data/TournamentController.dart';
import 'package:congrega/features/tournaments/model/Tournament.dart';
import 'package:congrega/features/tournaments/data/repositories/TournamentRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:kiwi/kiwi.dart';

import 'join_by_code_dialog.dart';

class TournamentPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => TournamentPage(new TournamentController(
            repository: KiwiContainer().resolve<TournamentRepository>())));
  }

  TournamentPage(TournamentController controller)
      : _tournamentController = controller;

  final TournamentController _tournamentController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.events_page_title),
          actions: [
            IconButton(icon: Icon(Icons.search), onPressed: () => {}),
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry>[
                  new PopupMenuItem(
                      child: Text(
                          AppLocalizations.of(context)!.events_action_create)),
                  new PopupMenuItem(
                      child: Text(
                          AppLocalizations.of(context)!.events_action_search)),
                ];
              },
            ),
          ],
        ),
        drawer: CongregaDrawer(),
        floatingActionButton: FloatingActionButton.extended(
          label: Text(AppLocalizations.of(context)!
              .events_join_by_code
              .toString()
              .toUpperCase()),
          onPressed: () => _showJoinByCodeDialog(context),
        ),
        body: BlocProvider.value(
          value: KiwiContainer().resolve<TournamentBloc>(),
          child: _EventList(tournamentController: _tournamentController),
        ));
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

class _EventList extends StatefulWidget {
  _EventList({required this.tournamentController});

  final TournamentController tournamentController;

  @override
  State<StatefulWidget> createState() =>
      _EventListState(tournamentController: tournamentController);
}

class _EventListState extends State<_EventList> {
  final TournamentController tournamentController;

  static const TextStyle sectionHeaderStyle =
      TextStyle(fontSize: 15, color: Color.fromRGBO(0, 0, 0, 0.54));

  _EventListState({required this.tournamentController});

  List<Tournament> tournamentList = [];

  @override
  void initState() {
    super.initState();
    loadList();
  }

  Future loadList({Function()? callback}) async {
    List<Tournament> tournamentList = await tournamentController.getEventList();
    setState(() {
      this.tournamentList = tournamentList;
      if (callback != null) callback();
    });
  }

  Future refreshList() async {
    loadList(callback: () {
      final snackBar = SnackBar(content: Text('Event list updated.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return tournamentList.isEmpty
        ? Center(child: CircularProgressIndicator())
        : RefreshWidget(
            onRefresh: refreshList,
            child: _buildListView(context, tournamentList));
  }

  Widget _buildListView(BuildContext context, List<Tournament> eventList) {
    List<Tournament> participatedList =
        tournamentController.getParticipatedEvents();
    List<Tournament> createdList = tournamentController.getCreatedEvents();

    return ListView(physics: const AlwaysScrollableScrollPhysics(), children: [
      ..._buildSubList(
          participatedList,
          AppLocalizations.of(context)!
              .events_inProgress_label
              .toString()
              .toUpperCase()),
      ..._buildSubList(
          createdList,
          AppLocalizations.of(context)!
              .events_myevents_label
              .toString()
              .toUpperCase()),
      ..._buildSubList(
          eventList,
          AppLocalizations.of(context)!
              .events_nearby_label
              .toString()
              .toUpperCase()),
    ]);
  }

  Widget _eventRow(BuildContext context, Tournament tournament) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      openBuilder: (BuildContext _, VoidCallback openContainer) =>
          TournamentStatusPage(),
      closedBuilder: (BuildContext _, VoidCallback openContainer) => ListTile(
        onTap: () {
          BlocProvider.of<TournamentBloc>(context)
              .add(SetTournament(tournament));
          openContainer();
        },
        leading: CircleAvatar(child: Text(tournament.name[0])),
        title: Text(tournament.name,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        subtitle: Text(tournament.type),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                formatDateTime(tournament.startingTime),
                style: TextStyle(color: Colors.grey),
              ),
            )
          ],
        ),
      ),
    );
  }

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return "N/A";

    DateTime localDateTime = dateTime.toLocal();
    if (localDateTime.isBefore(DateTime.now())) return "In Progress";

    return DateFormat("dd/MM").format(localDateTime);
  }

  List<Widget> _buildSubList(
      List<Tournament> eventList, String? sectionHeader) {
    return [
      _buildSectionHeader(sectionHeader),
      ...new List.generate(eventList.length,
          (index) => _eventRow(context, eventList.elementAt(index))),
      Divider(),
    ];
  }

  Widget _buildSectionHeader(String? sectionHeaderText) {
    if (sectionHeaderText == null || sectionHeaderText.isEmpty)
      return Divider();

    return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Text(sectionHeaderText, style: sectionHeaderStyle));
  }
}