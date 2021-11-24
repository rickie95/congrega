import 'package:flutter/material.dart';

class TournamentChartTab extends StatelessWidget{

  Widget build(BuildContext context) {
    List<List<String>> points = [
      ["1", "JackMa", "5", "3-0-0"],
      ["2", "You", "4", "2-0-1"],
      ["3", "WiseWizard", "3", "2-1-0"]
    ];

    return Container(
        child: DataTable(

          columns: [
            DataColumn(label: Text("#")),
            DataColumn(label: Text("Name")),
            DataColumn(label: Text("Points"), numeric: true),
            DataColumn(label: Text("W-L-D"))
          ],

          rows: new List.generate(points.length, (index) => DataRow(
              cells: new List.generate(points.elementAt(index).length, (position)
              => DataCell( Text(points.elementAt(index).elementAt(position) ) )
              )
          ),
          ),
        )
    );
  }
}