import 'package:congrega/pages/CongregaDrawer.dart';
import 'package:flutter/material.dart';

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
          children: [
            Container(
              child: Text('Welcome back John', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    width: 8,
                    color: Colors.white12
                ),
              ),
            ),

            Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all( width: 8, color: Colors.green ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quick 1v1 match', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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


            Container( // Container eventi
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all( width: 8, color: Colors.green ),),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Events around you', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

            Container( // FRIENDS
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all( width: 8, color: Colors.green ),),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Friends', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Container(
                    height: 120,
                    padding: EdgeInsets.only(top: 6),
                    child: FriendCardList(),
                  )

                ],
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
