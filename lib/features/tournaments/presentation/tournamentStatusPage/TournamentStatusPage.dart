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
    return BlocProvider.value(
        value: KiwiContainer().resolve<TournamentBloc>(),
        child: _TournamentStatusPageScaffold(tournament));
  }
}

class _TournamentStatusPageScaffold extends StatelessWidget {
  const _TournamentStatusPageScaffold(this.tournament);

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(tournament.name),
          actions: [
            _popMenuButton(context),
          ],
        ),
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

  Widget eventRoundView(BuildContext context) {
    return TournamentEventDetailsView(tournament: this.tournament);
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
