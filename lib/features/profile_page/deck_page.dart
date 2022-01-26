import 'package:congrega/features/dashboard/presentation/widgets/DashboardWideTile.dart';
import 'package:congrega/features/drawer/CongregaDrawer.dart';
import 'package:congrega/features/profile_page/bloc/current_deck_stats_bloc/current_deck_stats_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';

import 'data/stats_repo.dart';

class DeckPage extends StatelessWidget {
  static const String pageTitle = "Decks";

  static Route route() => MaterialPageRoute<void>(builder: (_) => DeckPage());

  @override
  Widget build(BuildContext context) {
    CurrentDeckStatsBloc deckBloc = KiwiContainer().resolve<CurrentDeckStatsBloc>()
      ..add(LoadCurrentDeck());

    return Scaffold(
      appBar: AppBar(
        title: const Text(pageTitle),
        actions: [],
      ),
      drawer: CongregaDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
            context: context,
            builder: (context) => BlocProvider<CurrentDeckStatsBloc>.value(
                  value: deckBloc,
                  child: NewDeckDialog(),
                )),
        child: Icon(Icons.add),
      ),
      body: BlocProvider<CurrentDeckStatsBloc>(
        create: (context) => deckBloc,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              DashboardWideTile(
                title: "Current Deck",
                child: Center(
                  child: BlocBuilder<CurrentDeckStatsBloc, CurrentDeckState>(
                    bloc: deckBloc,
                    builder: (context, state) {
                      if (state is CurrentDeckUnknownState)
                        return Center(
                          child: CircularProgressIndicator(),
                        );

                      return DropdownButton<Deck>(
                        value: (state as CurrentDeckStatsState).currentDeck,
                        onChanged: (Deck? selectedDeck) => selectedDeck != null
                            ? BlocProvider.of<CurrentDeckStatsBloc>(context)
                                .add(CurrentDeckIsChanged(currentDeck: selectedDeck))
                            : null,
                        items: state.deckList
                            .map((Deck deck) =>
                                DropdownMenuItem<Deck>(value: deck, child: Text(deck.name)))
                            .toList(),
                      );
                    },
                  ),
                ),
              ),
              BlocBuilder<CurrentDeckStatsBloc, CurrentDeckState>(
                bloc: deckBloc,
                buildWhen: (previous, current) => previous != current,
                builder: (context, state) {
                  return DashboardWideTile(
                    title: "Decks",
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children:
                            createDeckRows(KiwiContainer().resolve<StatsRepo>().getDeckList()),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> createDeckRows(Future<List<Deck>> deckListFuture) {
    return [
      FutureBuilder(
        future: deckListFuture,
        builder: (context, AsyncSnapshot<List<Deck>> snapshot) {
          if (snapshot.hasData && snapshot.data != null)
            return Column(
              children: List.generate(
                snapshot.data!.length,
                (index) => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 90,
                        child: Text(
                          snapshot.data![index].name,
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.edit),
                          color: Colors.black54,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );

          if (snapshot.hasError)
            return Center(
              child: Container(
                child: Text("An error occurred, try again later"),
              ),
            );

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      )
    ];
  }
}

class NewDeckDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController deckNameController = TextEditingController();
    return AlertDialog(
      title: Text("Add new deck"),
      content: TextField(
        controller: deckNameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Deck name',
        ),
      ),
      actions: [
        OutlinedButton(onPressed: Navigator.of(context).pop, child: Text("Cancel")),
        Builder(builder: (context) {
          return ElevatedButton(
              onPressed: () {
                CurrentDeckStatsBloc bbb = context.read<CurrentDeckStatsBloc>();

                bbb.add(AddDeck(deck: Deck(name: deckNameController.text)));
                Navigator.of(context).pop();
              },
              child: Text("ADD"));
        })
      ],
    );
  }
}
