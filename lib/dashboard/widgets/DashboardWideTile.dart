import 'package:flutter/material.dart';

class DashboardWideTile extends StatelessWidget {
  const DashboardWideTile({
    Key key, this.title, this.child,
  }) : super(key: key);

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Material(
        elevation: 14,
        shadowColor:  Colors.black,
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Divider(),
              child,
            ],
          ),
        ),
      ),
    );
  }
}