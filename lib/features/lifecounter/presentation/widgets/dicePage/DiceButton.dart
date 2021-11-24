
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DiceButton extends StatefulWidget {

  static const TextStyle buttonLabelTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 18
  );

  const DiceButton({
    required this.iconData,
    required this.callback,
    required this.label,
  });

  final IconData iconData;
  final Function() callback;
  final String label;

  @override
  _DiceButtonState createState() => _DiceButtonState();

}

class _DiceButtonState extends State<DiceButton> with SingleTickerProviderStateMixin {

  late Widget _iconButton;
  late Widget _toBeDraw;
  late Timer? _timer;

  @override
  void initState() {
    super.initState();

    _iconButton = Column(
        children: [
          IconButton(
              icon: Icon(widget.iconData),
              color: Colors.white,
              iconSize: 70,
              onPressed: () => startAnimation()),
          Text(widget.label, style: DiceButton.buttonLabelTextStyle)
        ]
    );
    _toBeDraw = _iconButton;
    _timer = null;
  }

  void startAnimation() {
    String value = widget.callback();
    setState(() {
      _toBeDraw = _createResultButton(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 33,
      child: AnimatedSwitcher(
          duration: const Duration(seconds: 5),
          child: _toBeDraw
      ),
    );
  }

  Widget _createResultButton(String value) {
    _timer = Timer(Duration(seconds: 2), () {
      if (mounted)
        setState(() => _toBeDraw = _iconButton);
    });
    return Column(
        children: [
          TextButton(
              onPressed: () {
                setState(() => _toBeDraw = _iconButton);
              },
              child: Text(
                value, style: TextStyle(color: Colors.white, fontSize: 60),)
          ),
          Text("", style: DiceButton.buttonLabelTextStyle)
        ]
    );
  }

  @override
  void dispose() {
    if (_timer != null)
      _timer!.cancel();
    super.dispose();
  }

}