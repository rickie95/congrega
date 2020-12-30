import 'package:congrega/theme/CongregaTheme.dart';
import 'package:flutter/material.dart';

class CongregaTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String errorText;
  final IconData icon;
  final bool obscureText;
  final Function validator;

  const CongregaTextFormField({Key key, this.controller, this.hintText,
    this.errorText, this.icon, this.obscureText, this.validator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          prefixIcon: Icon(this.icon),
          border: InputBorder.none,
          enabledBorder: congregaTextFieldBorder(),
          focusedBorder: congregaTextFieldBorder(),
          errorBorder:congregaTextFieldBorder(),
          focusedErrorBorder: congregaTextFieldBorder(),
          helperText: ' ',
          hintText: this.hintText,
            errorStyle: TextStyle(
              color: CongregaTheme.textColor,
            )
        ),
      validator: validator,
    );
  }

  static OutlineInputBorder congregaTextFieldBorder(){
    return OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.white,
            width: 32.0),
        borderRadius: BorderRadius.circular(97.0));
  }
}