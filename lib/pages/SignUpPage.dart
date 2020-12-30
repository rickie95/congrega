import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

import '../controllers/UserController.dart';
import '../ui/CongregaCallToActionAnimatedButton.dart';
import '../ui/CongregaCircleLogo.dart';
import '../ui/animations/DelayedAnimation.dart';
import '../model/User.dart';
import '../forms/CongregaTextFormField.dart';
import '../forms/Validators.dart';
import '../theme/CongregaTheme.dart';

void main() {
  runApp(SignUpPage());
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with SingleTickerProviderStateMixin {

  final int delayedAmount = -500;
  double _scale;
  AnimationController _controller;

  final String greetingLineOne = "What about you?";
  final String confirmationButtonMessage = "Confirm";

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _passwordCheckController = new TextEditingController();
  final TextEditingController _nameController = new TextEditingController();

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
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    final color = Colors.white;

    final CongregaTextFormField nameTextFormField = CongregaTextFormField(
        validator: Validators.alwaysTrueValidator,
        controller: _nameController,
        hintText: "Name (Optional)",
        errorText: errorText,
        icon: Icons.assignment_ind_rounded,
        obscureText: false);

    final Widget usernameTextFormField =  CongregaTextFormField(
        validator: Validators.usernameValidator,
        controller: _usernameController,
        hintText: "Username",
        errorText: "You need to specify an username",
        icon: Icons.account_circle_sharp,
        obscureText: false);

    final CongregaTextFormField passwordTextFormField = CongregaTextFormField(
        validator: Validators.passwordValidator,
        controller: _passwordController,
        hintText: "Password",
        errorText: errorText,
        icon: Icons.vpn_key,
        obscureText: true);

    final CongregaTextFormField passwordCheckTextFormField = CongregaTextFormField(
        validator: Validators.passwordValidator,
        controller: _passwordCheckController,
        hintText: "Enter again your password",
        errorText: errorText,
        icon: Icons.vpn_key,
        obscureText: true);

    final Widget signUpForm = Form(
        key: _formKey,
        child: Column(
            children: <Widget>[
              DelayedAnimation(
                  child: nameTextFormField,
                  delay: delayedAmount + 1500),
              DelayedAnimation(
                  child: usernameTextFormField,
                  delay: delayedAmount + 1500),
              DelayedAnimation(
                  child: passwordTextFormField,
                  delay: delayedAmount + 1500),
              DelayedAnimation(
                  child: passwordCheckTextFormField,
                  delay: delayedAmount + 1500),
            ]
        )
    );

    final Widget confirmationButton = CongregaCallToActionAnimatedButton(
      scale: _scale,
      controller: _controller,
      buttonText: confirmationButtonMessage,
      callback: formValidationCallback,
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

                    signUpForm,

                    SizedBox(
                      height: 20.0,
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

  void formValidationCallback(){
    // Basic validation is already managed by single textFields
    // TODO: perform elaborate checks, such as double check password and username availability

    // password are the same
    String passwordOne = _passwordController.text.toString();
    String passwordTwo = _passwordCheckController.text.toString();
    if(passwordOne != passwordTwo){
      // show dialog
      return;
    }

    String username = _usernameController.text.toString();
    if(!UserController.checkUsernameAvailability(username)){
      // show dialog
      return;
    }
    // Collect optional info
    String name = _nameController.text.toString();

    // then send POST, this might be a FUTURE
    UserController.saveNewUser(User(username, passwordOne, name));
  }

}
