import 'package:congrega/theme/CongregaTheme.dart';
import 'package:flutter/material.dart';

class CongregaTextFormField extends StatelessWidget {
  final String hintText;
  final String errorText;
  final IconData icon;
  final bool obscureText;
  final Function onChanged;
  final IconButton suffixIcon;

  const CongregaTextFormField({Key key, this.hintText,
    this.errorText, this.icon, this.obscureText, this.onChanged, this.suffixIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          prefixIcon: Icon(this.icon),
          suffixIcon: this.suffixIcon != null ? this.suffixIcon : null,
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