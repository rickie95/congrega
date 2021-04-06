import 'package:congrega/features/authentication/AuthenticationBloc.dart';
import 'package:congrega/features/authentication/AuthenticationRepository.dart';
import 'package:congrega/features/authentication/AuthenticationState.dart';
import 'package:congrega/features/lifecounter/presentation/LifeCounterPage.dart';
import 'package:congrega/features/tournaments/presentation/tournamentPage/TournamentPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kiwi/kiwi.dart';

import '../dashboard/presentation/HomePage.dart';

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
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () => showLogoutAlertDialog(context),
          )
        ],
      ),
    );
  }

  void showLogoutAlertDialog(BuildContext context){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure to log off your account?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel")),
          ElevatedButton(
              onPressed: () {
                KiwiContainer().resolve<AuthenticationRepository>().logOut();
                Navigator.pop(context);
              },
              child: Text("Logout"))
        ],
        elevation: 5,
      );
    });
  }

}

class _CongregaDrawerHeader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Congrega', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
          Divider(),
          BlocProvider(create: (BuildContext context) => KiwiContainer().resolve<AuthenticationBloc>(),
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                String headerUsername = state.user.username;
                if(state.user.name.isNotEmpty)
                  headerUsername += ' (${state.user.name})';
                return Text(headerUsername);
              },
            ),
          )
        ],
      ),
    );
  }

}