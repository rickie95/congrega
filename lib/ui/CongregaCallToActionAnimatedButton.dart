import 'package:flutter/material.dart';
import 'package:congrega/theme/CongregaTheme.dart';

class CongregaCallToActionAnimatedButton extends StatelessWidget {

  final double scale;
  final AnimationController controller;
  final String buttonText;
  final Function()? callback;
  final bool enabled;


  CongregaCallToActionAnimatedButton({
    Key? key,
    required this.scale,
    required this.controller,
    required this.buttonText,
    this.callback,
    this.enabled = true
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTap: this.enabled ? callback : null,
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
      color: this.enabled ? CongregaTheme.callToActionButtonBackground : CongregaTheme.callToActionButtonBackgroundDisabled,
       // Color.alphaBlend(CongregaTheme.callToActionButtonBackground, CongregaTheme.primaryColor),
      boxShadow: [BoxShadow(
        color: CongregaTheme.callToActionButtonShadow,
        offset: const Offset(0, 20),
        blurRadius: 40.0,
        spreadRadius: 0.0,)]
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