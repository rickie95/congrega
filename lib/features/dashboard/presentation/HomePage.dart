import 'package:congrega/features/lifecounter/presentation/LifeCounterPage.dart';
import 'package:congrega/features/drawer/CongregaDrawer.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/match/MatchBloc.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/match/MatchEvents.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/features/users/UserRepository.dart';
import 'package:congrega/features/websocket/invitation_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kiwi/kiwi.dart';

import 'widgets/DashboardTinyTile.dart';
import 'widgets/EventsWidget.dart';
import 'widgets/friends_widget/FriendsWidget.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static const String pageTitle = "Dashboard";
  late InvitationManager invitationManager;

  @override
  void initState() {
    super.initState();
    invitationManager = KiwiContainer().resolve<InvitationManager>();
  }

  @override
  Widget build(BuildContext context) {
    invitationManager.setOnMessageCallback((Message message) {
      switch (message.type) {
        case MessageType.CHALLENGES:
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Text("Hai ricevuto un invito"),
              content: Container(
                child: Text(
                    "${message.senderUsername} ti vuole sfidare in un 1v1, che cosa vuoi fare?"),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      showWaitForMatchInfoDialog(context, message);
                    },
                    child: Text("Accetta")),
                TextButton(
                    onPressed: () {
                      invitationManager.declineInvite(
                          message, User(id: message.senderId, username: message.senderUsername));
                      Navigator.of(context).pop();
                    },
                    child: Text("Rifiuta")),
              ],
            ),
          );
          break;
        default:
      }
    });
    return Scaffold(
      appBar: AppBar(title: const Text(pageTitle)),
      drawer: CongregaDrawer(),
      body: HomePageWidgetList(),
    );
  }

  void showWaitForMatchInfoDialog(BuildContext context, Message invite) {
    final Duration timeLimit = Duration(seconds: 10);

    showDialog(
      context: context,
      builder: (context) {
        invitationManager
            .acceptInvite(invite)
            .timeout(timeLimit, onTimeout: () => throw TimeoutError())
            .then(
          (Message matchDetails) {
            Navigator.of(context).pop();
            showSuccessDialog(context, matchDetails);
          },
        ).onError(
          (error, stackTrace) {
            Navigator.of(context).pop();
            if (error is TimeoutError)
              showErrorDialog(context, "Timeout!",
                  "Match information has not been received in a reasonable time.");
          },
        );

        return AlertDialog(
          title: Text("Please wait"),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("I'm fetching the match's information, it will take a few seconds."),
                SizedBox(),
                CircularProgressIndicator()
              ],
            ),
          ),
        );
      },
    );
  }

  showSuccessDialog(BuildContext context, Message matchDetails) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        Future.delayed(
          Duration(seconds: 2),
          () {
            Navigator.of(context).pop();
            KiwiContainer().resolve<MatchBloc>().add(
                  FetchOnline1vs1Match(opponent: matchDetails.sender, matchId: matchDetails.data!),
                );
            Navigator.of(context).push(LifeCounterPage.route());
          },
        );
        return AlertDialog(
          title: Text("Everything set!"),
          content: Text(
              "${matchDetails.senderUsername} is ready, sharpen your axe or what, you're starting now!"),
        );
      },
    );
  }

  void showErrorDialog(BuildContext context, String title, String text) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Dismiss"),
          ),
        ],
      ),
    );
  }
}

class HomePageWidgetList extends StatelessWidget {
  Future<String> getUsername() async {
    return KiwiContainer().resolve<UserRepository>().getUser().then(
        (User loggedUser) => loggedUser.name.isNotEmpty ? loggedUser.name : loggedUser.username);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 10),
      children: [
        Container(
          child: FutureBuilder(
            future: getUsername(),
            builder: (context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const Text('');
              if (snapshot.hasData && snapshot.data != null)
                return Text(AppLocalizations.of(context)!.dashboard_message + " " + snapshot.data!,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
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
      ],
    );
  }
}
