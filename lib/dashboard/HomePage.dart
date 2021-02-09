import 'package:congrega/dashboard/widgets/EventsWidget.dart';
import 'package:congrega/dashboard/widgets/FriendsWidget.dart';
import 'package:congrega/lifecounter/view/LifeCounterPage.dart';
import 'package:congrega/pages/CongregaDrawer.dart';
import 'package:flutter/material.dart';

import 'widgets/DashboardTinyTile.dart';

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


            EventsWidget(),
            FriendsWidget(),
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





