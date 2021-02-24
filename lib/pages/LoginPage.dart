import 'package:congrega/authentication/AuthenticationRepository.dart';
import 'package:congrega/forms/CongregaLoginForm.dart';
import 'package:congrega/login/LoginBloc.dart';
import 'package:congrega/ui/CongregaCircleLogo.dart';
import 'package:flutter/material.dart';
import 'package:congrega/theme/CongregaTheme.dart';
import 'package:congrega/ui/animations/DelayedAnimation.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class LoginPage extends StatefulWidget {

  static Route route (){
    return MaterialPageRoute(builder: (_) => LoginPage());
  }

  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>  with SingleTickerProviderStateMixin {

  final int delayedAmount = -500;
  double _scale;
  AnimationController _controller;

  final String greetingLineOne = "Welcome back!";

  final String descriptionLineOne = "Enter your credentials";
  final String descriptionLineTwo = "and you'll be ready to play";

  final String confirmationButtonMessage = "Login";

  @override
  void initState() {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
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
                            authenticationRepository:
                              RepositoryProvider.of<AuthenticationRepository>(context),
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
