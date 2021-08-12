import 'package:congrega/features/friends/data/friends_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kiwi/kiwi.dart';

import 'DashboardWideTile.dart';

class FriendsWidget extends StatelessWidget {
  const FriendsWidget();

  void handleChoice(String choice) {}

  @override
  Widget build(BuildContext context) {
    return DashboardWideTile(
        title: AppLocalizations.of(context)!.friends_widget_title,
        popupMenuButton: PopupMenuButton<String>(
          onSelected: handleChoice,
          itemBuilder: (BuildContext context) {
            return {'Add friend'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
        child: Container(
          height: 125,
          child: FriendCardList(),
        ));
  }
}

class FriendCardList extends StatelessWidget {
  const FriendCardList();

  int getFriendCount() {
    return KiwiContainer().resolve<FriendRepository>().getFriendsList().length;
  }

  @override
  Widget build(BuildContext context) {
    if (getFriendCount() == 0) {
      return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 2, color: Colors.black54),
          ),
          child: Center(
            child: Text("You have no friends! Tap here to add someone"),
          ));
    }

    return ListView(
      scrollDirection: Axis.horizontal,
      children: KiwiContainer()
          .resolve<FriendRepository>()
          .getFriendsList()
          .map((friend) => FriendCard(username: friend.username))
          .toList(),
    );
  }
}

class FriendCard extends StatelessWidget {
  final String username;

  @override
  FriendCard({required this.username}) : super();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                username[0].toUpperCase(),
                style: TextStyle(fontSize: 30),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Text(username)
          ],
        ),
      ),
    );
  }
}
