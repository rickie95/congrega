import 'dart:ui';

import 'package:congrega/authentication/AuthenticationBloc.dart';
import 'package:congrega/model/User.dart';
import 'package:congrega/pages/CongregaDrawer.dart';
import 'package:congrega/lifecounter/view/LifeCounterPage.dart';
import 'package:congrega/tournament/bloc/TournamentBloc.dart';
import 'package:congrega/tournament/bloc/TournamentState.dart';
import 'package:congrega/tournament/controller/TournamentController.dart';
import 'package:congrega/tournament/model/Tournament.dart';
import 'package:congrega/tournament/views/tournamentStatusPage/ConfirmLeavingTournamentDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ConfirmJoiningEventDialog.dart';

class TournamentStatusPage extends StatelessWidget {

  static Route route(Tournament t) {
    return MaterialPageRoute<void>(builder: (_) => TournamentStatusPage(t));
  }

  TournamentStatusPage(Tournament tournament) : _tournament = tournament, super();

  final Tournament _tournament;

  TournamentState _getTournamentState(){
    return TournamentState(
        tournament: _tournament,
        enrolled: false,
        round: 0,
        status: TournamentStatus.inProgress
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: BlocProvider<TournamentBloc>(
            create: (BuildContext context) => new TournamentBloc(initialState: _getTournamentState(), controller: TournamentController.getInstance()),
            child: Scaffold(
                appBar: AppBar(
                  title: Text(_tournament.name),
                  actions: [
                    _popMenuButton(context),
                  ],
                  bottom: TabBar(
                    tabs: [
                      Tab(child: Text("Round")),
                      Tab(child: Text("Chart"))
                    ],
                  ),
                ),

                drawer: CongregaDrawer(),
                body: TabBarView(
                  children: [
                    eventRoundView(context),
                    eventChartView(context)
                  ],
                )
            )));
  }

  Widget eventChartView(BuildContext context) {
    List<List<String>> points = [
      ["1", "JackMa", "5", "3-0-0"],
      ["2", "You", "4", "2-0-1"],
      ["3", "WiseWizard", "3", "2-1-0"]
    ];

    return Container(
        child: DataTable(

          columns: [
            DataColumn(label: Text("#")),
            DataColumn(label: Text("Name")),
            DataColumn(label: Text("Points"), numeric: true),
            DataColumn(label: Text("W-L-D"))
          ],

          rows: new List.generate(points.length, (index) => DataRow(
              cells: new List.generate(points.elementAt(index).length, (position)
              => DataCell( Text(points.elementAt(index).elementAt(position) ) )
              )
          ),
          ),
        )
    );
  }

  String formattedDate(DateTime now) => "${now.day.toString().padLeft(2,'0')} ${now.month.toString().padLeft(2,'0')}";
  String formatTime(DateTime now) => "${now.hour.toString()}:${now.minute.toString().padLeft(2,'0')}";

  String adminsListToString(Set<User> admins){
    String string = "";
    for(User ad in admins){
      string += ad.name == null ? "${ad.username} " : "${ad.username} (${ad.name}) ";
    }
    return string;
  }

  Widget _notEnrolledView(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              padding: const EdgeInsets.only(top: 15, bottom: 10),
              child: Text(_tournament.name, style: const TextStyle(fontSize: 25),),
            ),

            Row(
              children: [
                Icon(Icons.circle, size: 10),
                Container(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(_tournament.type, style: const TextStyle(fontSize: 15)))
              ],
            ),

            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: [
                  Expanded(
                      flex: 20,
                      child: Container(
                          child: Column(
                              children: [
                                Text("21", style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                                Text("Feb", style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w300)),
                              ]
                          )
                      )
                  ),

                  Expanded(
                      flex: 80,
                      child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Row( children: [
                                Icon(Icons.access_time_outlined, color: Color.fromRGBO(0, 0, 0, 0.6),),
                                Container(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(formatTime(_tournament.startingTime),
                                      style: const TextStyle(
                                          fontSize: 17,
                                          color: Color.fromRGBO(0, 0, 0, 0.6)
                                      ),
                                    )
                                )
                              ],
                              ),
                            ),
                            Container(
                              child: Row(
                                  children: [
                                    Icon(Icons.location_pin, color: Color.fromRGBO(0, 0, 0, 0.6),),
                                    Container(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text("35 Kensington Road, London",
                                          style: const TextStyle(
                                              fontSize: 17,
                                              color: Color.fromRGBO(0, 0, 0, 0.6)
                                          ),
                                        )
                                    )
                                  ]
                              ),
                            )
                          ]
                      )
                  ),

                ],
              ),
            ),

            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text("ABOUT THE EVENT", style: TextStyle(fontSize: 15, color: Colors.grey),),
                  ),


                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text("${_tournament.playerList.length}", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    child: Text("Participants", style: TextStyle(fontSize: 17)),
                  ),


                  // Container(child: Text("MODERATORS ${adminsListToString(_tournament.adminList)}")),

                ],
              ),
            ),





            Spacer(),
            Divider(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 50,
                    child: Center(
                      child: RaisedButton(
                        color: Colors.redAccent,
                        onPressed: () {},
                        child: Text("ADD TO CALENDAR"),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 50,
                    child: Center(
                      child: RaisedButton(
                        color: Colors.lightBlue,
                        onPressed: () => showDialog<void>(
                            context: context,
                            builder: (_) =>
                                BlocProvider.value(
                                  value: BlocProvider.of<TournamentBloc>(context),
                                  child: ConfirmJoiningEventDialog(),
                                )
                        ),
                        child: Text("JOIN EVENT"),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        )
    );
  }

  Widget _roundInProgressPage(BuildContext context){
    User opponent = User(
        username: "WizeWizard"
    );

    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
              flex: 20,
              child: Center(
                  child: Text("Round 1 of 3", style: TextStyle(fontSize: 20)))
          ),

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
                              Text("You", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                              Container(
                                padding: EdgeInsets.only(top: 20),
                                child: Text("0", style: TextStyle(fontSize: 50),),
                              )
                            ],
                          ),),


                        Expanded(
                          flex: 50,
                          child: Column(
                            children: [
                              Text(opponent.username, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                              Container(
                                padding: EdgeInsets.only(top: 20),
                                child: Text("0", style: TextStyle(fontSize: 50),),
                              )

                            ],
                          ),),

                      ],
                    ),

                    Container(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                            children: [
                              Text("Ending 16:00", style: TextStyle(fontSize: 20),),
                              Container(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child: Text("Table 13", style: TextStyle(fontSize: 25),),
                              )
                            ]
                        )

                    ),
                  ],
                ),
              )
          ),

          Expanded(
              flex: 10,
              child: Container(
                child: RaisedButton(
                  onPressed: () => Navigator.of(context)
                      .push(LifeCounterPage.route(opponent: opponent)),
                  child: Text("LIFE COUNTER"),
                ),
              )
          )

        ],
      ),
    );
  }

  Widget eventRoundView(BuildContext context){
    return BlocBuilder<TournamentBloc, TournamentState>(
        buildWhen: (previous, current) =>
        (previous.tournament.round != current.tournament.round) ||
            (previous.enrolled != current.enrolled) || (previous.status != current.status),
        builder: (context, state) {

          // If ENDED or the user is not enrolled show the details page
          if(state.status == TournamentStatus.ended || !state.tournament.isUserEnrolled(BlocProvider.of<AuthenticationBloc>(context).state.user))
            return _notEnrolledView(context);

          // If WAITING then standby until admin's action
          if(state.status == TournamentStatus.waiting)
            return _standbyForAdmin(context);

          // Otherwise is in INPROGRESS, then show the round page
          return _roundInProgressPage(context);
        });
  }

  Widget _standbyForAdmin(BuildContext context){
    return Container(
      padding: EdgeInsets.all(16),
      child: Material(
        elevation: 14,
        shadowColor: Colors.grey,
        child:  Column(
          children: [
            Center(child: Text("PLEASE STANDBY")),
            Center(child: Text("Wait for the round's start")),
            Center(child: Text("Remember to follow indications from organizers and judges"))
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
            switch (value){
              case "LEAVE_TOURNAMENT":
                showDialog(context: context, builder: (_) =>
                    BlocProvider.value(
                      value: BlocProvider.of<TournamentBloc>(context),
                      child: ConfirmLeavingEventDialog(),
                    )
                );
                break;
              case "TOURNAMENT_DETAILS":

                break;
            }
          },
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry>[
              new PopupMenuItem(
                child: Text("Leave tournament"),
                value: "LEAVE_TOURNAMENT",
                enabled: state.enrolled,
              ),
              new PopupMenuItem(
                child: Text("Tournament info"),
                value: "TOURNAMENT_DETAILS",
                enabled: false,
              ),
            ];
          },
        );
      },
    );
  }
}