import 'package:flutter/material.dart';

class DashboardWideTile extends StatelessWidget {
  const DashboardWideTile(
      {required this.title, required this.child, this.popupMenuButton, this.subtitle});

  final String title;
  final Widget child;
  final Widget? popupMenuButton;
  final String? subtitle;

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
              subtitle != null
                  ? Text(subtitle!.toUpperCase(),
                      style: TextStyle(fontSize: 15, color: Colors.black45))
                  : Container(),
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
            child: Text(title, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          ),
          this.popupMenuButton ?? Container()
        ],
      ),
    );
  }
}
