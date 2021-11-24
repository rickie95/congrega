import 'package:flutter/material.dart';
import 'dart:math' as math;

class DashboardWideTile extends StatelessWidget {
  const DashboardWideTile(
      {required this.title, required this.child, this.popupMenuButton});

  final String title;
  final Widget child;
  final PopupMenuButton? popupMenuButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Material(
        elevation: 14,
        shadowColor: Colors.black,
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleBar(),
              Divider(),
              child,
            ],
          ),
        ),
      ),
    );
  }

  Widget titleBar() {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Text(title,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          ),
          this.popupMenuButton != null
              ? Transform.rotate(
                  angle: math.pi / 2,
                  child: popupMenuButton,
                )
              : Container()
        ],
      ),
    );
  }
}
