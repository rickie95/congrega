import 'package:flutter/material.dart';
import 'package:congrega/theme/CongregaTheme.dart';

class CongregaCallToActionAnimatedButton extends StatelessWidget {

  final double scale;
  final AnimationController controller;
  final String buttonText;
  final Function callback;


  CongregaCallToActionAnimatedButton({Key key, this.scale,
    this.controller, this.buttonText, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTap: callback,
        child: Transform.scale(
          scale: scale,
          child: _animatedButtonUI,
        ));
  }

  Widget get _animatedButtonUI => Container(
    height: 60,
    width: 270,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100.0),
      color: Colors.white,
    ),
    child: Center(
      child: Text( buttonText,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: CongregaTheme.congregaTheme().primaryColor,
        ),
      ),
    ),
  );

  void _onTapDown(TapDownDetails details) {
    controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    controller.reverse();
  }
}