import 'package:congrega/features/lifecounter/presentation/LifeCounterPage.dart';
import 'package:congrega/features/tournaments/presentation/tournamentPage/TournamentPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../features/dashboard/presentation/HomePage.dart';

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
            leading: Icon(Icons.home),
              title: Text(AppLocalizations.of(context)!.homepage_title),
              onTap: () {
                Navigator.push(context, HomePage.route());
              }
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text(AppLocalizations.of(context)!.tournament_page_title),
            onTap: () {
              Navigator.push(context, TournamentPage.route());
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(AppLocalizations.of(context)!.lifecounter_page_title),
            onTap: () {
              Navigator.push(context, LifeCounterPage.route());
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.account_circle_sharp),
            title: Text(AppLocalizations.of(context)!.profile_page_title),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(AppLocalizations.of(context)!.settings_page_title),
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