import 'dart:ui';

import 'package:congrega/features/authentication/AuthenticationBloc.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/features/tournaments/presentation/bloc/TournamentBloc.dart';
import 'package:congrega/features/tournaments/presentation/bloc/TournamentEvent.dart';
import 'package:congrega/features/tournaments/presentation/bloc/TournamentState.dart';
import 'package:congrega/features/drawer/CongregaDrawer.dart';
import 'package:congrega/features/lifecounter/presentation/LifeCounterPage.dart';
import 'package:congrega/features/tournaments/model/Tournament.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:uuid/uuid.dart';

import 'ConfirmLeavingTournamentDialog.dart';
import 'TournamentChartTab.dart';
import 'TournamentEventDetailsView.dart';

enum POPMENU_ACTIONS {
  MANAGE_TOURNAMENT,
  LEAVE_TOURNAMENT,
  SHOW_TOURNAMENT_INFO,
}

class TournamentStatusPage extends StatelessWidget {
  final Tournament tournament;

  static Route route(Tournament t) {
    return MaterialPageRoute<void>(builder: (_) => TournamentStatusPage(t));
  }

  const TournamentStatusPage(this.tournament);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: BlocProvider.value(
            value: KiwiContainer().resolve<TournamentBloc>(),
            child: _TournamentStatusPageScaffold(tournament)));
  }
}

class _TournamentStatusPageScaffold extends StatelessWidget {
  const _TournamentStatusPageScaffold(this.tournament);

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(BlocProvider.of<TournamentBloc>(context).state.tournament.name),
          actions: [
            _popMenuButton(context),
          ],
        ),
        drawer: BlocProvider.of<TournamentBloc>(context).state.enrolled ? CongregaDrawer() : null,
        body: eventRoundView(context));
  }

  String formattedDate(DateTime now) =>
      "${now.day.toString().padLeft(2, '0')} ${now.month.toString().padLeft(2, '0')}";
  String formatTime(DateTime now) =>
      "${now.hour.toString()}:${now.minute.toString().padLeft(2, '0')}";

  String adminsListToString(Set<User> admins) {
    String string = "";
    for (User ad in admins) {
      string += (ad.name.isEmpty ? "${ad.username} " : "${ad.username} (${ad.name}) ");
    }
    return string;
  }

  Widget _roundInProgressPage(BuildContext context) {
    User opponent = User(id: Uuid().toString(), username: "WizeWizard");

    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
              flex: 20, child: Center(child: Text("Round 1 of 3", style: TextStyle(fontSize: 20)))),
          Expanded(
              flex: 70,
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 50,
                          child: Column(
                            children: [
                              Text(
                                "You",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 20),
                                child: Text(
                                  "0",
                                  style: TextStyle(fontSize: 50),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: Column(
                            children: [
                              Text(
                                opponent.username,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 20),
                                child: Text(
                                  "0",
                                  style: TextStyle(fontSize: 50),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(children: [
                          Text(
                            "Ending 16:00",
                            style: TextStyle(fontSize: 20),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: Text(
                              "Table 13",
                              style: TextStyle(fontSize: 25),
                            ),
                          )
                        ])),
                  ],
                ),
              )),
          Expanded(
              flex: 10,
              child: Container(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(LifeCounterPage.route()),
                  child: Text("LIFE COUNTER"),
                ),
              ))
        ],
      ),
    );
  }

  Widget eventRoundView(BuildContext context) {
    return TournamentEventDetailsView(tournament: this.tournament);

    return BlocBuilder<TournamentBloc, TournamentState>(
        buildWhen: (previous, current) =>
            (previous.tournament.round != current.tournament.round) ||
            (previous.enrolled != current.enrolled) ||
            (previous.status != current.status),
        builder: (context, state) {
          // If ENDED or the user is not enrolled show the details page
          if (state.status == TournamentStatus.ENDED ||
              state.status == TournamentStatus.SCHEDULED ||
              !state.tournament
                  .isUserEnrolled(BlocProvider.of<AuthenticationBloc>(context).state.user))
            return TournamentEventDetailsView(tournament: state.tournament);

          // If WAITING then standby until admin's action
          if (state.status == TournamentStatus.WAITING) return _standbyForAdmin(context);

          // Otherwise is in INPROGRESS, then show the round page
          return _roundInProgressPage(context);
        });
  }

  Widget _standbyForAdmin(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Material(
        elevation: 14,
        borderRadius: BorderRadius.circular(12),
        shadowColor: Colors.grey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "PLEASE STANDBY",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                )),
            Container(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "Wait for the round's start",
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: EdgeInsets.only(top: 30),
              child: Icon(
                Icons.access_time_outlined,
                size: 100,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.only(top: 30, left: 12, right: 12),
                    child: Text(
                      "Notes",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    )),
                Container(
                    padding: EdgeInsets.only(top: 10, left: 12, right: 12),
                    child: Text("Follow indications from organizers and judges.")),
                Container(
                    padding: EdgeInsets.only(top: 10, left: 12, right: 12),
                    child: Text("Be kind and help people around you")),
                Container(
                    padding: EdgeInsets.only(top: 10, left: 12, right: 12),
                    child: Text("Have fun!")),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _popMenuButton(BuildContext context) {
    return BlocBuilder<TournamentBloc, TournamentState>(
      builder: (context, state) {
        return PopupMenuButton(
          onSelected: (value) {
            switch (value) {
              case POPMENU_ACTIONS.LEAVE_TOURNAMENT:
                showDialog(
                    context: context,
                    builder: (_) => BlocProvider.value(
                          value: BlocProvider.of<TournamentBloc>(context),
                          child: ConfirmLeavingEventDialog(),
                        ));
                break;
              case POPMENU_ACTIONS.SHOW_TOURNAMENT_INFO:
                break;
              case POPMENU_ACTIONS.MANAGE_TOURNAMENT:
                break;
            }
          },
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry>[
              new PopupMenuItem(
                child: Text("Leave tournament"),
                value: POPMENU_ACTIONS.LEAVE_TOURNAMENT,
                enabled: state.enrolled,
              ),
              new PopupMenuItem(
                child: Text("Tournament info"),
                value: POPMENU_ACTIONS.SHOW_TOURNAMENT_INFO,
                enabled: false,
              ),
              new PopupMenuItem(
                child: Text("Manage.."),
                value: POPMENU_ACTIONS.MANAGE_TOURNAMENT,
                enabled: true,
              )
            ];
          },
        );
      },
    );
  }

  TournamentEvent getNextState(TournamentStatus status) {
    if (status == TournamentStatus.SCHEDULED) return WaitForRound();

    if (status == TournamentStatus.WAITING) return RoundIsAvailable();

    if (status == TournamentStatus.IN_PROGRESS) return EndTournament();

    if (status == TournamentStatus.ENDED) return TournamentIsScheduled();

    return TournamentIsScheduled();
  }

  bool _statusIsEndedOrInProgressOrWaiting(TournamentStatus status) {
    return status == TournamentStatus.IN_PROGRESS ||
        status == TournamentStatus.WAITING ||
        status == TournamentStatus.ENDED;
  }
}
