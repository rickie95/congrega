import 'package:congrega/pages/LifeCounterPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'HomePage.dart';

class CongregaDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return Drawer (

      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          _CongregaDrawerHeader(),
          ListTile(
              title: Text(HomePage.pageTitle),
              onTap: () {
                Navigator.push(context, HomePage.route());
              }
          ),
          ListTile(
            title: Text('Tournament'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: Text('Life counter'),
            onTap: () {
              Navigator.push(context, LifeCounterPage.route());
            },
          ),
          ListTile(
            title: Text('My Profile'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
        ],
      ),
    );
  }

}

class _CongregaDrawerHeader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return
      Container(
        height: 120,
          child: DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Congrega', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                const Padding(padding: EdgeInsets.all(6)),
                Text('John Doe / DragonSlayer27')
              ],
            ),


          )
      );
  }

}