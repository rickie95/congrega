import 'package:flutter/material.dart';
import 'package:congrega/ui/animations/DelayedAnimation.dart';
import 'package:congrega/forms/CongregaTextFormField.dart';

class CongregaForm extends StatefulWidget {

  @override
  _CongregaFormState createState() => _CongregaFormState();

}

class _CongregaFormState extends State<CongregaForm> {

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();
  final int delayedAmount = 500;

  Widget _form;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    _form = Form(
        key: _formKey,
        child: Column(
            children: <Widget>[
              DelayedAnimation(child:
              CongregaTextFormField(
                  controller: _usernameController,
                  hintText: "Username",
                  errorText: "Username can't be empty",
                  icon: Icons.account_circle_sharp,
                  obscureText: false),
                  delay: delayedAmount + 3000),
              SizedBox( height: 10.0,),
              DelayedAnimation(child:
              CongregaTextFormField(
                  controller: _passwordController,
                  hintText: "Password",
                  errorText: "Password can't be empty",
                  icon: Icons.vpn_key,
                  obscureText: true),
                  delay: delayedAmount + 3000),
            ]
        )
    );

    return _form;
  }

  GlobalKey getFormKey(){
    return _formKey;
  }

  Map<String, String> getCredentials(){
    return {
      "username": _usernameController.text.toString(),
      "password": _passwordController.text.toString()
    };
  }

}