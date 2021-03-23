import 'package:congrega/authentication/AuthenticationBloc.dart';
import 'package:congrega/authentication/AuthenticationRepository.dart';
import 'package:congrega/authentication/AuthenticationState.dart';
import 'package:congrega/features/dashboard/presentation/HomePage.dart';
import 'package:congrega/injector.dart';
import 'package:congrega/ui/CongregaCircleLogo.dart';
import 'package:flutter/material.dart';
import 'package:congrega/theme/CongregaTheme.dart';
import 'package:congrega/ui/animations/DelayedAnimation.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';

import 'bloc/LoginBloc.dart';
import 'forms/CongregaLoginForm.dart';


class LoginPage extends StatefulWidget {

  static Route route (){
    return MaterialPageRoute(builder: (_) => LoginPage());
  }

  LoginPage() : super();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>  with SingleTickerProviderStateMixin {

  final int delayedAmount = -500;
  late double _scale;
  late AnimationController _controller;

  final String greetingLineOne = "Welcome back!";

  final String descriptionLineOne = "Enter your credentials";
  final String descriptionLineTwo = "and you'll be ready to play";

  final String confirmationButtonMessage = "Login";

  @override
  void initState() {
    DepInj.setup();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 100,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    KiwiContainer().clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
   return BlocListener<AuthenticationBloc, AuthenticationState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if(state.status == AuthenticationStatus.authenticated)
            Navigator.pushAndRemoveUntil<void>(context, HomePage.route(), (route) => false);
        },
        child: buildPage(context),
    );
  }

  Widget buildPage(BuildContext context){
    final color = Colors.white;
    _scale = 1 - _controller.value;
    final Widget loginForm = CongregaLoginForm(_scale, delayedAmount, _controller);

    return MaterialApp(
        home: Scaffold (
          backgroundColor: CongregaTheme.congregaTheme().primaryColor,
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                child: Column(

                  children: <Widget>[
                    AvatarGlow(
                      endRadius: 90,
                      duration: Duration(seconds: 2),
                      glowColor: Colors.white24,
                      repeat: true,
                      repeatPauseDuration: Duration(seconds: 2),
                      startDelay: Duration(seconds: 1),
                      child: Material(
                          elevation: 8.0,
                          shape: CircleBorder(),
                          child: CongregaCircleLogo()),
                    ),

                    DelayedAnimation(
                      child: Text(
                        greetingLineOne,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35.0,
                            color: color),
                      ),
                      delay: delayedAmount + 500,
                    ),

                    SizedBox(
                      height: 20.0,
                    ),

                    DelayedAnimation(
                      child: Text(
                        descriptionLineOne,
                        style: TextStyle(fontSize: 20.0, color: color),
                      ),
                      delay: delayedAmount + 1000,
                    ),

                    DelayedAnimation(
                      child: Text(
                        descriptionLineTwo,
                        style: TextStyle(fontSize: 20.0, color: color),
                      ),
                      delay: delayedAmount + 1000,
                    ),

                    SizedBox(
                      height: 40.0,
                    ),

                    BlocProvider(
                      create: (context) {
                        return LoginBloc(
                            authenticationRepository: KiwiContainer().resolve<AuthenticationRepository>()
                        );
                      },
                      child: loginForm,
                    )

                  ],
                ),
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 40.0),
              ),
            ),
          ),
        )
    );
  }

}
