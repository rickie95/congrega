import 'package:congrega/features/friends/data/friends_repository.dart';
import 'package:congrega/features/friends/presentation/search_friends_page.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kiwi/kiwi.dart';

import 'DashboardWideTile.dart';

class FriendsWidget extends StatelessWidget {
  const FriendsWidget();

  void handleChoice(String choice, BuildContext context) {
    switch (choice) {
      case 'Add friend':
        Navigator.push(context, SearchFriendPage.route());
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardWideTile(
        title: AppLocalizations.of(context)!.friends_widget_title,
        popupMenuButton: PopupMenuButton<String>(
          onSelected: (choice) => handleChoice(choice, context),
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
          .map((friend) => FriendCard(user: friend))
          .toList(),
    );
  }
}

class FriendCard extends StatelessWidget {
  final User user;

  @override
  FriendCard({required this.user}) : super();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showModalBottomSheet<void>(
          context: context, builder: (BuildContext context) => FriendBottomSheet(user: user)),
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                child: Text(
                  user.username[0].toUpperCase(),
                  style: TextStyle(fontSize: 30),
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Text(user.username)
            ],
          ),
        ),
      ),
    );
  }
}

class FriendBottomSheet extends StatelessWidget {
  final User user;

  FriendBottomSheet({required this.user}) : super();

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(14),
      children: [titleRow(), actionsContainer()],
    );
  }

  Widget titleRow() {
    return Row(
      children: [
        Expanded(
          flex: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [userTitle(), userName()],
          ),
        ),
        Column(
          children: [
            IconButton(
                onPressed: () => {},
                icon: Icon(
                  KiwiContainer().resolve<FriendRepository>().isFriendWith(user)
                      ? Icons.star
                      : Icons.star_outline,
                  size: 30,
                ))
          ],
        )
      ],
    );
  }

  Widget userTitle() {
    return Text(
      user.username,
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    );
  }

  Widget userName() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          user.name,
          style: TextStyle(fontSize: 15),
        ));
  }

  Widget actionsContainer() {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          OutlinedButton(
            child: Text("ENGAGE"),
            onPressed: () => {},
          )
        ],
      ),
    );
  }
}
