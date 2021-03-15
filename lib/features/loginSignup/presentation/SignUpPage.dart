import 'package:avatar_glow/avatar_glow.dart';
import 'package:congrega/features/loginSignup/presentation/bloc/signup/SignUpBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as BLOC;
import '../../../ui/CongregaCircleLogo.dart';
import '../../../ui/animations/DelayedAnimation.dart';
import '../../../theme/CongregaTheme.dart';
import 'forms/CongregaSignUpForm.dart';

class SignUpPage extends StatelessWidget {

  final SignUpService signUpService = SignUpService();

  @override
  Widget build(BuildContext context) {
    return  BLOC.RepositoryProvider.value(
      value: signUpService,
      child: BLOC.BlocProvider(
        create: (_) => SignUpBloc(signUpService: signUpService),
        child: SignUpView(),
      ),
    );
  }

  static Route route (){
    return MaterialPageRoute(builder: (_) => SignUpPage());
  }

}


class SignUpView extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();

}

class _SignUpPageState extends State<SignUpView> with SingleTickerProviderStateMixin {

  final int delayedAmount = -500;
  late double _scale;
  late AnimationController _controller;

  final String greetingLineOne = "What about you?";
  final String confirmationButtonMessage = "Confirm";

  String errorText = "Password can't be empty";


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
    _scale = 1 - _controller.value;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    final color = Colors.white;

    final Widget signUpForm = CongregaSignUpForm(_scale, delayedAmount, _controller);

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

                    BlocProvider(
                      create: (context) {
                        return SignUpBloc(
                            signUpService:
                            RepositoryProvider.of<SignUpService>(context));
                      },
                      child: signUpForm,
                    ),

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
