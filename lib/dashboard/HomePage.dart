import 'package:congrega/lifecounter/view/LifeCounterPage.dart';
import 'package:congrega/pages/CongregaDrawer.dart';
import 'package:flutter/material.dart';

import 'DashboardTinyTile.dart';

void main(){
  runApp(HomePage());
}

class HomePage extends StatelessWidget {

  static const String pageTitle = "Dashboard";

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(pageTitle)),
      drawer: CongregaDrawer(),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10),
          children: [

            Container(
              child: Text('Welcome back John', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              padding: EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    width: 8,
                    color: Colors.white12
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                children: [
                  
                  Expanded(
                    flex: 50,
                    child: DashboardTinyTile("Quick Match", "START A DUEL", Icons.favorite, Colors.redAccent, () => Navigator.of(context).push(LifeCounterPage.route())),
                  ),
                  
                  Expanded(
                    flex: 50,
                    child: DashboardTinyTile("My Profile", "CHECK YOUR STATS", Icons.account_circle_sharp, Colors.indigo, () => debugPrint("NOT ASSIGNED YET")),
                  ),
                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Material(
                elevation: 14,
                shadowColor:  Colors.black,
                borderRadius: BorderRadius.circular(12.0),
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Events', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Divider(),
                        Column (
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            RaisedButton(onPressed: () {}, ),
                            RaisedButton(onPressed: () {}, ),
                            RaisedButton(onPressed: () {}, ),
                          ],
                        ),
                        Text('See more events')
                      ],
                    )
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Material(
                elevation: 14,
                shadowColor:  Colors.black,
                borderRadius: BorderRadius.circular(12.0),
                child: Container( // FRIENDS
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Friends', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Divider(),
                      Container(
                        height: 120,
                        child: FriendCardList(),
                      )

                    ],
                  ),
                ),
              ),
            ),

          ]
      ),

    );
  }


  void requestLogout(){
    //context.read<AuthenticationBloc>().add(AuthenticationLogoutRequested());
  }

  String getUsername(){
    // returns either the user's name or his username
    return "John";
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
