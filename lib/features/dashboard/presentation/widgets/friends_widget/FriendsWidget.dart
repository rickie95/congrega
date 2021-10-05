import 'package:congrega/features/dashboard/presentation/widgets/friends_widget/bloc/friends_widget_bloc.dart';
import 'package:congrega/features/dashboard/presentation/widgets/friends_widget/bloc/friends_widget_events.dart';
import 'package:congrega/features/dashboard/presentation/widgets/friends_widget/bloc/friends_widget_state.dart';
import 'package:congrega/features/friends/data/friends_repository.dart';
import 'package:congrega/features/friends/presentation/search_friends_page.dart';
import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:congrega/features/lifecounter/presentation/LifeCounterPage.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/LifeCounterBloc.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/match/MatchBloc.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/match/MatchEvents.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kiwi/kiwi.dart';
import 'package:provider/provider.dart';

import '../DashboardWideTile.dart';

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
        child: BlocProvider<FriendsWidgetBloc>(
            create: (BuildContext context) => KiwiContainer().resolve<FriendsWidgetBloc>(),
            child: FriendCardList()),
      ),
    );
  }
}

class FriendCardList extends StatelessWidget {
  const FriendCardList();

  Future<void> friendListIsReady() {
    return KiwiContainer().resolve<FriendRepository>().fetchFriendsList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: KiwiContainer().resolve<FriendRepository>().fetchFriendsList(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text("Ops, something went wrong");

        if (snapshot.hasData) return FriendsWidgetBody();

        return CircularProgressIndicator();
      },
    );
  }
}

class FriendsWidgetBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendsWidgetBloc, FriendsWidgetState>(
      builder: (context, state) {
        if (KiwiContainer().resolve<FriendRepository>().isEmpty()) {
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
      },
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
      children: [titleRow(), actionsContainer(context)],
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
        FollowButton(user: user),
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

  Widget actionsContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          ElevatedButton(
            child: Text("CHALLENGE HIM!"),
            onPressed: () {
              KiwiContainer().resolve<MatchBloc>().add(Create1V1Match(opponent: user));
              Navigator.of(context).push(LifeCounterPage.route());
            },
          )
        ],
      ),
    );
  }
}

class FollowButton extends StatefulWidget {
  final User user;

  FollowButton({required this.user});

  @override
  State<FollowButton> createState() => _FollowButtonState(user: user);
}

class _FollowButtonState extends State<FollowButton> {
  User user;

  _FollowButtonState({required this.user}) : super();

  @override
  Widget build(BuildContext context) {
    return KiwiContainer().resolve<FriendRepository>().isFriendWith(user)
        ? OutlinedButton(
            onPressed: () {
              KiwiContainer().resolve<FriendRepository>().removeFriend(user);
              KiwiContainer().resolve<FriendsWidgetBloc>().add(FriendListUpdated(
                  listLenght: KiwiContainer().resolve<FriendRepository>().getFriendsList().length));
              setState(() {});
            },
            child: Text("Unfollow"))
        : OutlinedButton(
            onPressed: () {
              KiwiContainer().resolve<FriendRepository>().addFriend(user);
              KiwiContainer().resolve<FriendsWidgetBloc>().add(FriendListUpdated(
                  listLenght: KiwiContainer().resolve<FriendRepository>().getFriendsList().length));
              setState(() {});
            },
            child: Text("Follow"));
  }
}
