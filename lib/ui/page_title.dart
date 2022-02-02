import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  final Widget child;

  const PageTitle({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      padding: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 8, color: Colors.white12),
      ),
    );
  }

  static Widget createTitleText(String text) {
    return Text(text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
  }
}
