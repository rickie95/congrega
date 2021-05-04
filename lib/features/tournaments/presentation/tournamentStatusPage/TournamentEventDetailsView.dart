import 'package:congrega/features/tournaments/model/Tournament.dart';
import 'package:congrega/features/tournaments/presentation/bloc/TournamentBloc.dart';
import 'package:congrega/features/tournaments/presentation/bloc/TournamentState.dart';
import 'package:congrega/ui/congrega_elevated_button_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'ConfirmJoiningEventDialog.dart';

class TournamentEventDetailsView extends StatelessWidget {
  
  TournamentEventDetailsView({required this.tournament}) : super();
  
  final Tournament tournament;

  static String formattedDate(DateTime now) => "${now.day.toString().padLeft(2,'0')} ${now.month.toString().padLeft(2,'0')}";
  static String formatTime(DateTime now) => "${now.hour.toString()}:${now.minute.toString().padLeft(2,'0')}";
  
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              padding: const EdgeInsets.only(top: 15, bottom: 10),
              child: Text(tournament.name, style: const TextStyle(fontSize: 25),),
            ),

            Row(
              children: [
                Icon(Icons.circle, size: 10),
                Container(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(tournament.type, style: const TextStyle(fontSize: 15)))
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
                                Text(tournament.startingTime!.day.toString(), style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                                Text(DateFormat.MMMM().format(tournament.startingTime!).substring(0,3), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w300)),
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
                                    child: Text(formatTime(tournament.startingTime!),
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


                  Row(
                    children: [



                      Expanded(
                        flex: 50,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Text("${tournament.playerList.length}", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                                ),
                                Container(
                                  child: Text("Participants", style: TextStyle(fontSize: 17)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 50,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: BlocBuilder<TournamentBloc, TournamentState>(
                                    buildWhen: (previous, current) => previous.status != current.status,
                                    builder: (context, state) {
                                      return Text(statusToString(state.status), style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold));
                                    },
                                  ),
                                ),
                                Container(
                                  child: Text("Status", style: TextStyle(fontSize: 17)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    ],
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
                      child: ElevatedButton(
                        style: elevatedDangerButtonStyle,
                        onPressed: () {},
                        child: Text("ADD TO CALENDAR"),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 50,
                    child: Center(
                      child: ElevatedButton(
                        style: elevatedActionButtonStyle,
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

  String statusToString(TournamentStatus status) {
    if(status == TournamentStatus.scheduled)
      return "Scheduled";

    if(status == TournamentStatus.waiting || status == TournamentStatus.inProgress)
      return "In Progress";

    if(status == TournamentStatus.ended)
      return "Ended";

    // FIXME: use log
    debugPrint("WARNING: unknown TournamentStatus enum => $status");
    return "Unknown";
  }
}