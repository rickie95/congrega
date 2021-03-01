import 'package:congrega/pages/WelcomePage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'authentication/AuthenticationRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as BLOC;

import 'package:congrega/dashboard/HomePage.dart';
import 'package:congrega/pages/SplashPage.dart';

import 'package:congrega/user/UserRepository.dart';

import 'package:congrega/authentication/AuthenticationBloc.dart';
import 'package:congrega/authentication/AuthenticationState.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class Congrega extends StatelessWidget {
  final UserRepository userRepository;
  final AuthenticationRepository authenticationRepository;

  const Congrega({Key key,
    @required this.authenticationRepository,
    @required this.userRepository}) :
        assert(authenticationRepository!= null),
        assert(userRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BLOC.RepositoryProvider.value(
      value: authenticationRepository,
      child: BLOC.BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository,
        ),
        child: CongregaView(),
      ),
    );
  }
}

class CongregaView extends StatefulWidget {
  @override
  _CongregaViewState createState() => _CongregaViewState();
}

class _CongregaViewState extends State<CongregaView>{
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Congrega',
     // theme: CongregaTheme.congregaTheme(),
      navigatorKey: _navigatorKey,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('it')
      ],
      builder: (context, child) {
        return BLOC.BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.unauthenticated:
                _navigator.pushAndRemoveUntil<void>(HomePage.route(), (route) => false);
                break;
              case AuthenticationStatus.authenticated:
                _navigator.pushAndRemoveUntil<void>(WelcomePage.route(), (route) => false);
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}

