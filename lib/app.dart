import 'package:congrega/injector.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kiwi/kiwi.dart';

import 'features/authentication/AuthenticationRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:congrega/features/dashboard/presentation/HomePage.dart';

import 'package:congrega/features/authentication/AuthenticationBloc.dart';
import 'package:congrega/features/authentication/AuthenticationState.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'features/splashscreen/SplashPage.dart';
import 'features/splashscreen/WelcomePage.dart';

class Congrega extends StatelessWidget {
  const Congrega();

  @override
  Widget build(BuildContext context) {
    return CongregaView();
  }
}

class CongregaView extends StatefulWidget {
  @override
  _CongregaViewState createState() => _CongregaViewState();
}

class _CongregaViewState extends State<CongregaView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState? get _navigator => _navigatorKey.currentState;

  @override
  void initState() {
    super.initState();
    DepInj.setup();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => KiwiContainer().resolve<AuthenticationBloc>(),
      child: MaterialApp(
        title: 'Congrega',
        // theme: CongregaTheme.congregaTheme(),
        navigatorKey: _navigatorKey,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: [const Locale('en'), const Locale('it')],
        builder: (context, childWidget) {
          return MultiBlocListener(
            listeners: [
              // Listener for authentication state
              BlocListener<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {
                  switch (state.status) {
                    case AuthenticationStatus.authenticated:
                      _navigator!.pushAndRemoveUntil<void>(HomePage.route(), (route) => false);
                      break;
                    case AuthenticationStatus.unauthenticated:
                      _navigator!.pushAndRemoveUntil<void>(WelcomePage.route(), (route) => false);
                      break;
                    default:
                      break;
                  }
                },
              ),
            ],
            child: childWidget!,
          );
        },
        onGenerateRoute: (_) => SplashPage.route(),
      ),
    );
  }
}
