import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'DashboardWideTile.dart';

class FriendsWidget extends StatelessWidget {
  const FriendsWidget();

  @override
  Widget build(BuildContext context) {
    return DashboardWideTile(
        title: AppLocalizations.of(context)!.friends_widget_title,
        child: Container(
          height: 120,
          child: FriendCardList(),
        )
    );
  }
}

class FriendCardList extends StatelessWidget {
  const FriendCardList();

  int getFriendCount(){
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    if(getFriendCount() == 0){
      return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all( width: 2, color: Colors.black54 ),),
          child: Center(
            child:  Text("You have no friends! Tap here to add someone"),
          )
      );
    }

    return ListView (
      scrollDirection: Axis.horizontal,
      children:  new List.generate(10, (int index) {
        return new Card(
          color: Colors.blue[index * 100],
          child: new Container(
            width: 120.0,
            child: new Text("$index"),
          ),
        );
      }),
    );
  }
}