import 'package:congrega/features/dashboard/presentation/widgets/DashboardWideTile.dart';
import 'package:congrega/features/drawer/CongregaDrawer.dart';
import 'package:congrega/ui/page_title.dart';
import 'package:flutter/material.dart';

enum ProfilePageAppBarActions { RESTORE_STATS, MANAGE_DECK }

class ProfilePage extends StatelessWidget {
  static const String pageTitle = "Profile";

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ProfilePage());
  }

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
      body: Padding(
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
                    createStatRow(statEntry("Total Matches"), statEntry("34")),
                    createStatRow(statEntry("Winrate"), statEntry("50%")),
                  ],
                ),
              ),
            ),

            DashboardWideTile(
              title: "Current Deck",
              subtitle: "MB PESTILENCE",
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Column(
                  children: [
                    createStatRow(statEntry("Total Matches"), statEntry("5")),
                    createStatRow(statEntry("Winrate"), statEntry("80%")),
                  ],
                ),
              ),
            ),

            DashboardWideTile(
              title: "Recent History",
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Column(
                  children: [
                    createStatRow(statEntry("LGG2"), statEntry("2 - 0")),
                    createStatRow(statEntry("DanBor"), statEntry("2 - 1")),
                    createStatRow(statEntry("MagicMike"), statEntry("0 - 2")),
                    createStatRow(statEntry("DanBor"), statEntry("2 - 1")),
                  ],
                ),
              ),
            )
            // Stats totali
            // totale incontri
            // % vinte

            // breakdown per deck corrente

            // Ultimi tre match
          ],
        ),
      ),
    );
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
}
