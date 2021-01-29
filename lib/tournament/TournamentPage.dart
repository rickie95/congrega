import 'package:congrega/pages/CongregaDrawer.dart';
import 'package:congrega/theme/CongregaTheme.dart';
import 'package:flutter/material.dart';

class TournamentPage extends StatelessWidget{

  static const String pageTitle = "Tournaments";

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => TournamentPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text(pageTitle),),
        drawer: CongregaDrawer(),
        body: _eventList(context)
    );
  }

  Widget _eventList(BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Text("My events", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
          ),


          Container(
              margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                    flex: 10,
                    child: Icon(Icons.assignment_ind_rounded)),
                Expanded(
                  flex: 80,
                  child: Text("John's House Limited", style: TextStyle(fontSize: 15),),
                ),
                Expanded(
                    flex: 10,
                    child: Icon(Icons.arrow_forward_ios_rounded)
                )



              ],
            )
          ),

          Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                      flex: 10,
                      child: Icon(Icons.assignment_ind_rounded)),
                  Expanded(
                    flex: 80,
                    child: Text("Magic Mike Constructed", style: TextStyle(fontSize: 15),),
                  ),
                  Expanded(
                      flex: 10,
                      child: Icon(Icons.arrow_forward_ios_rounded)
                  )



                ],
              )
          ),

          Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                      flex: 10,
                      child: Icon(Icons.assignment_ind_rounded)),
                  Expanded(
                    flex: 80,
                    child: Text("Calamity Store Draft", style: TextStyle(fontSize: 15),),
                  ),
                  Expanded(
                      flex: 10,
                      child: Icon(Icons.arrow_forward_ios_rounded)
                  )



                ],
              )
          )

        ],
      ),
    );
  }


  Widget _noTournamentAvailableContainer(BuildContext context) {
    return Center(
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: CongregaTheme.primaryColor,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text("You're not enrolled in any event yet",
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),

            RaisedButton(child: Text("CREATE NEW EVENT"), onPressed: () {}),
            RaisedButton(child: Text("SEARCH FOR EVENTS"), onPressed: () {})
          ],
        ),
      ),
    );
  }

}

