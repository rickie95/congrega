import 'package:congrega/features/dashboard/presentation/widgets/DashboardWideTile.dart';
import 'package:congrega/features/drawer/CongregaDrawer.dart';
import 'package:congrega/features/profile_page/bloc/current_deck_stats_bloc/current_deck_stats_bloc.dart';
import 'package:congrega/features/profile_page/data/stats_repo.dart';
import 'package:congrega/features/profile_page/deck_page.dart';
import 'package:congrega/ui/page_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';

enum ProfilePageAppBarActions { RESTORE_STATS, MANAGE_DECK }

class ProfilePage extends StatelessWidget {
  static const String pageTitle = "Profile";

  static Route route() => MaterialPageRoute<void>(builder: (_) => ProfilePage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(pageTitle),
        actions: [
          PopupMenuButton(
            onSelected: (ProfilePageAppBarActions selection) =>
                _handleSelection(context, selection),
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<ProfilePageAppBarActions>>[
                new PopupMenuItem<ProfilePageAppBarActions>(
                    value: ProfilePageAppBarActions.RESTORE_STATS, child: Text("Reset stats")),
              ];
            },
          ),
        ],
      ),
      drawer: CongregaDrawer(),
      body: BlocProvider<CurrentDeckStatsBloc>(
        create: (context) =>
            KiwiContainer().resolve<CurrentDeckStatsBloc>()..add(LoadCurrentDeck()),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView(
            children: [
              PageTitle(child: PageTitle.createTitleText("Pixel")),
              DashboardWideTile(
                title: "Matches",
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Column(
                    children: [
                      createStatRow(
                          statEntry("Total Matches"),
                          statEntry(
                              KiwiContainer().resolve<StatsRepo>().recordListLength().toString())),
                      createStatRow(
                          statEntry("Winrate"),
                          statEntry(
                              "${(KiwiContainer().resolve<StatsRepo>().getWinrate() * 100).truncate()}%")),
                    ],
                  ),
                ),
              ),
              BlocBuilder<CurrentDeckStatsBloc, CurrentDeckState>(
                buildWhen: (previous, current) =>
                    previous != current ||
                    previous is CurrentDeckUnknownState && current is CurrentDeckStatsState ||
                    previous as CurrentDeckStatsState != current as CurrentDeckStatsState,
                builder: (context, state) {
                  return DashboardWideTile(
                    title: "Current Deck",
                    subtitle: state is CurrentDeckUnknownState
                        ? "..."
                        : "${(state as CurrentDeckStatsState).currentDeck.name}",
                    popupMenuButton: OutlinedButton(
                        child: Text("MANAGE DECKS"),
                        onPressed: () {
                          Navigator.of(context).push(DeckPage.route());
                          // CurrentDeckStatsBloc bloc =
                          //     BlocProvider.of<CurrentDeckStatsBloc>(context);

                          // showDialog(
                          //   context: context,
                          //   builder: (context) => BlocProvider<CurrentDeckStatsBloc>.value(
                          //     value: bloc,
                          //     child: showDeckDialog(context),
                          //   ),
                          // );
                        }),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Column(
                        children: [
                          createStatRow(
                            statEntry("Total Matches"),
                            FutureBuilder(
                              future: KiwiContainer()
                                  .resolve<StatsRepo>()
                                  .getRecordLengthForCurrentDeck(),
                              builder: (context, AsyncSnapshot<int> lengthSnap) {
                                if (lengthSnap.hasData && lengthSnap.data != null)
                                  return statEntry(lengthSnap.data.toString());

                                return statEntry("-");
                              },
                            ),
                          ),
                          createStatRow(
                            statEntry("Winrate"),
                            FutureBuilder(
                              future:
                                  KiwiContainer().resolve<StatsRepo>().getWinrateForCurrentDeck(),
                              builder: (context, AsyncSnapshot<double> winrateSnap) {
                                if (winrateSnap.hasData && winrateSnap.data != null)
                                  return statEntry("${(winrateSnap.data! * 100).truncate()}%");

                                return statEntry("-");
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
              DashboardWideTile(
                title: "Recent History",
                subtitle: "LATEST 10 MATCHES",
                popupMenuButton: OutlinedButton(
                  onPressed: null,
                  child: Container(),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Column(
                      children:
                          getRecordList(KiwiContainer().resolve<StatsRepo>().getRecordList())),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getRecordList(List<StatsRecord> recordList) {
    return List.generate(
        recordList.length,
        (index) => createStatRow(statEntry(recordList[index].opponentUsername),
            statEntry("${recordList[index].userScore} - ${recordList[index].opponentScore}")));
  }

  _handleSelection(BuildContext context, ProfilePageAppBarActions selection) {
    switch (selection) {
      case ProfilePageAppBarActions.RESTORE_STATS:
        // TODO: cancella tutto
        break;
      case ProfilePageAppBarActions.MANAGE_DECK:
        // TODO: cancella tutto
        break;
      default:
    }
  }

  Widget createStatRow(Widget header, Widget body) {
    return Row(
      children: [
        Expanded(
          child: header,
        ),
        Expanded(
          child: Center(child: body),
        )
      ],
    );
  }

  final TextStyle textEntryStyle = TextStyle(color: Colors.black87, fontSize: 16);

  Widget statEntry(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(text, style: textEntryStyle),
      );

  // showDeckDialog(BuildContext context) {
  //   return AlertDialog(
  //     title: Text("Select a Deck"),
  //     content: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text("Current deck in use:"),
  //         Center(
  //           child: BlocBuilder<CurrentDeckStatsBloc, CurrentDeckState>(
  //             buildWhen: (previous, current) =>
  //                 previous != current ||
  //                 previous is CurrentDeckUnknownState && current is CurrentDeckStatsState ||
  //                 (previous as CurrentDeckStatsState) != (current as CurrentDeckStatsState),
  //             builder: (context, state) {
  //               if (state is CurrentDeckUnknownState)
  //                 return Center(
  //                   child: CircularProgressIndicator(),
  //                 );

  //               return DropdownButton<Deck>(
  //                 value: (state as CurrentDeckStatsState).currentDeck,
  //                 onChanged: (Deck? selectedDeck) => selectedDeck != null
  //                     ? BlocProvider.of<CurrentDeckStatsBloc>(context)
  //                         .add(CurrentDeckIsChanged(currentDeck: selectedDeck))
  //                     : null,
  //                 items: KiwiContainer()
  //                     .resolve<StatsRepo>()
  //                     .getDeckList()
  //                     .map((Deck deck) =>
  //                         DropdownMenuItem<Deck>(value: deck, child: Text(deck.name)))
  //                     .toList(),
  //               );
  //             },
  //           ),
  //         ),
  //         Center(
  //             child: OutlinedButton(
  //                 onPressed: () => Navigator.of(context).push(DeckPage.route()),
  //                 // showDialog(
  //                 //     context: context, builder: (context) => createNewDeckDialog(context)),
  //                 child: Text("ADD NEW DECK")))
  //       ],
  //     ),
  //     actions: [ElevatedButton(onPressed: Navigator.of(context).pop, child: Text("CLOSE"))],
  //   );
  // }

  createNewDeckDialog(BuildContext context) {
    TextEditingController textController = new TextEditingController();

    return AlertDialog(
      title: Text("Create new deck"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: textController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Insert deck name',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: Navigator.of(context).pop, child: Text("Cancel")),
        ElevatedButton(
            onPressed: () {
              KiwiContainer().resolve<StatsRepo>().addDeck(new Deck(name: textController.text));
              Navigator.of(context).pop();
            },
            child: Text("SAVE"))
      ],
    );
  }
}
