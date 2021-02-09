import 'package:flutter/material.dart';

class DashboardTinyTile extends StatelessWidget {
  const DashboardTinyTile(this.title, this.subtitle, this.icon,
      this.iconColor, this.callback, { Key key, }) : super(key: key);

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Function() callback;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () => callback(),
        child: Material(
          elevation: 14,
          shadowColor:  Colors.black,
          borderRadius: BorderRadius.circular(12.0),
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  Padding(padding: EdgeInsets.only(bottom: 1),),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey),),
                  Padding(padding: EdgeInsets.only(bottom: 5),),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Material (
                        borderRadius: BorderRadius.circular(12.0),
                        color: iconColor,
                        child: Padding (
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(icon, color: Colors.white, size: 25.0),
                        )
                    ),
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }
}
