import 'package:congrega/features/lifecounter/presentation/LifeCounterPage.dart';
import 'package:congrega/features/drawer/CongregaDrawer.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/features/users/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kiwi/kiwi.dart';

import 'widgets/DashboardTinyTile.dart';
import 'widgets/EventsWidget.dart';
import 'widgets/friends_widget/FriendsWidget.dart';

void main() {
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
      body: ListView(padding: EdgeInsets.symmetric(horizontal: 10), children: [
        Container(
          child: FutureBuilder(
            future: getUsername(),
            builder: (context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return const Text('');
              if (snapshot.hasData && snapshot.data != null)
                return Text(
                    AppLocalizations.of(context)!.dashboard_message +
                        " " +
                        snapshot.data!,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
              return const Text('');
            },
          ),
          padding: EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 8, color: Colors.white12),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            children: [
              Expanded(
                flex: 50,
                child: DashboardTinyTile(
                    AppLocalizations.of(context)!.quick_match,
                    AppLocalizations.of(context)!.quick_match_subtitle,
                    Icons.favorite,
                    Colors.redAccent,
                    () => Navigator.of(context).push(LifeCounterPage.route())),
              ),
              Expanded(
                flex: 50,
                child: DashboardTinyTile(
                    AppLocalizations.of(context)!.my_profile_title,
                    AppLocalizations.of(context)!.my_profile_subtitle,
                    Icons.account_circle_sharp,
                    Colors.orange,
                    () => debugPrint("NOT ASSIGNED YET")),
              ),
            ],
          ),
        ),
        EventsWidget(),
        FriendsWidget(),
      ]),
    );
  }

  void requestLogout() {
    //context.read<AuthenticationBloc>().add(AuthenticationLogoutRequested());
  }

  Future<String> getUsername() async {
    return KiwiContainer().resolve<UserRepository>().getUser().then(
        (User loggedUser) =>
            loggedUser.name.isNotEmpty ? loggedUser.name : loggedUser.username);
  }
}
