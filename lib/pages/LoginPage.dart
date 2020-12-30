import 'package:congrega/ui/CongregaCircleLogo.dart';
import 'package:congrega/controllers/CredentialsController.dart';
import 'package:flutter/material.dart';
import 'package:congrega/theme/CongregaTheme.dart';
import 'package:congrega/ui/animations/DelayedAnimation.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:congrega/forms/CongregaTextFormField.dart';
import 'package:congrega/ui/CongregaCallToActionAnimatedButton.dart';

void main() {
  runApp(LoginPage());
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>  with SingleTickerProviderStateMixin {

  final int delayedAmount = -500;
  double _scale;
  AnimationController _controller;

  final String greetingLineOne = "Welcome back!";
  final String greetingLineTwo = "";

  final String descriptionLineOne = "Enter your credentials";
  final String descriptionLineTwo = "and you'll be ready to play";

  final String confirmationButtonMessage = "Login";

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();


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
  Widget build(BuildContext context){
    final color = Colors.white;
    _scale = 1 - _controller.value;

    final Widget usernameTextFormField =  CongregaTextFormField(
        controller: _usernameController,
        hintText: "Username",
        errorText: "Username can't be empty",
        icon: Icons.account_circle_sharp,
        obscureText: false);

    final Widget passwordTextFormField = CongregaTextFormField(
        controller: _passwordController,
        hintText: "Password",
        errorText: "Password can't be empty",
        icon: Icons.vpn_key,
        obscureText: true);

    final Widget loginForm = Form(
              key: _formKey,
              child: Column(
                  children: <Widget>[
                    DelayedAnimation(
                        child: usernameTextFormField,
                        delay: delayedAmount + 1500),
                    SizedBox( height: 10.0,),
                    DelayedAnimation(
                        child: passwordTextFormField,
                        delay: delayedAmount + 1500),
                  ]
              )
          );

    final Widget confirmationButton = CongregaCallToActionAnimatedButton(
      scale: _scale,
      controller: _controller,
      buttonText: confirmationButtonMessage,
      callback: formValidationCallBack,
    );

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

                    loginForm,

                    SizedBox(
                      height: 30.0,
                    ),
                    DelayedAnimation(
                      child: confirmationButton,
                      delay: delayedAmount + 2000,
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

  void formValidationCallBack(){
    if (_formKey.currentState.validate()) {
      String username = _usernameController.text.toString();
      String password = _passwordController.text.toString();
      debugPrint('Sending data to NSA: $username $password');

      // send data to controller and ask for authentication
      CredentialsController.authenticate(username, password, (message){
        debugPrint(message);
      });

      //
    }
  }

}
