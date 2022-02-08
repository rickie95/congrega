import 'package:avatar_glow/avatar_glow.dart';
import 'package:congrega/features/loginSignup/presentation/LoginPage.dart';
import 'package:congrega/features/loginSignup/presentation/SignUpPage.dart';
import 'package:congrega/theme/CongregaTheme.dart';
import 'package:congrega/ui/CongregaCallToActionAnimatedButton.dart';
import 'package:congrega/ui/animations/DelayedAnimation.dart';
import 'package:flutter/material.dart';
import 'package:congrega/ui/CongregaCircleLogo.dart';

class WelcomePage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute(builder: (_) => WelcomePage());
  }

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with SingleTickerProviderStateMixin {
  final int delayedAmount = 500;
  late double _scale;
  late AnimationController _controller;

  final String greetingLineOne = "Hello there,";
  final String greetingLineTwo = "I'm Congrega";

  final String descriptionLineOne = "Your new MtG";
  final String descriptionLineTwo = "companion";

  final String signUpButtonMessage = "Hi Congrega";
  final String loginButtonMessage = "I already have an account";

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
  Widget build(BuildContext context) {
    final color = Colors.white;
    _scale = 1 - _controller.value;

    final Widget signUpButton = CongregaCallToActionAnimatedButton(
      scale: _scale,
      controller: _controller,
      buttonText: signUpButtonMessage,
      callback: goToSignUpPage,
    );

    final Widget loginButton = Container(
      child: Text(
        loginButtonMessage.toUpperCase(),
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: color),
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.white),
        borderRadius: BorderRadius.circular(100.0),
      ),
      padding: const EdgeInsets.all(15.0),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: CongregaTheme.congregaTheme().primaryColor,
        body: SafeArea(
            child: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 30,
                child: AvatarGlow(
                  endRadius: 90,
                  duration: Duration(seconds: 2),
                  glowColor: Colors.white24,
                  repeat: true,
                  repeatPauseDuration: Duration(seconds: 2),
                  startDelay: Duration(seconds: 1),
                  child:
                      Material(elevation: 8.0, shape: CircleBorder(), child: CongregaCircleLogo()),
                ),
              ),
              Expanded(
                flex: 35,
                child: Column(
                  children: [
                    DelayedAnimation(
                      child: Text(
                        greetingLineOne,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35.0, color: color),
                      ),
                      delay: delayedAmount + 1000,
                    ),
                    DelayedAnimation(
                      child: Text(
                        greetingLineTwo,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35.0, color: color),
                      ),
                      delay: delayedAmount + 2000,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    DelayedAnimation(
                      child: Text(
                        descriptionLineOne,
                        style: TextStyle(fontSize: 20.0, color: color),
                      ),
                      delay: delayedAmount + 3000,
                    ),
                    DelayedAnimation(
                      child: Text(
                        descriptionLineTwo,
                        style: TextStyle(fontSize: 20.0, color: color),
                      ),
                      delay: delayedAmount + 3000,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DelayedAnimation(
                      child: signUpButton,
                      delay: delayedAmount + 4000,
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    DelayedAnimation(
                      child: GestureDetector(
                        child: loginButton,
                        onTap: goToLoginPage,
                      ),
                      delay: delayedAmount + 5000,
                    ),
                    SizedBox(
                      height: 50.0,
                    )
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  void goToLoginPage() {
    Navigator.push(context, LoginPage.route());
  }

  void goToSignUpPage() {
    Navigator.push(context, SignUpPage.route());
  }
}
