import 'package:flutter/material.dart';

import 'DashboardWideTile.dart';

class FriendsWidget extends StatelessWidget {
  const FriendsWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashboardWideTile(
        title: 'Friends',
        child: Container(
          height: 120,
          child: FriendCardList(),
        )
    );
  }
}

class FriendCardList extends StatelessWidget {
  const FriendCardList({
    Key key,
  }) : super(key: key);

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