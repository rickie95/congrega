import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../../congrega_icons.dart';
import 'DiceButton.dart';

void showDicePage(BuildContext context){
  showGeneralDialog(
      context: context,
      barrierColor: Colors.black12.withOpacity(0.85),
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (_,__,___) =>
          SizedBox.expand(
            child: DicePage(),
          )
  );
}

class DicePage extends StatelessWidget {

  static const TextStyle headingTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 40,
      decoration: TextDecoration.none
  );

  static const TextStyle descriptionTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 20,
    decoration: TextDecoration.none,

  );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close, color: Colors.white, size: 45,))],
              ),
            ),
            Expanded(
              flex: 80,
              child: Center(
                child: Container(
                  child: Column(
                    children: [
                      Text("TAP TO ROLL", style: headingTextStyle),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        child: Text("Select a dice and enjoy the power of randomness.",
                            textAlign: TextAlign.center,
                            style: descriptionTextStyle),
                      ),
                      DiceRowSection()
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiceRowSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            children:[
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Row(
                    children: [
                      DiceButton(label: "Coin", iconData: Icons.monetization_on, callback: () {
                        Random randFactory = Random(DateTime.now().second);
                        return randFactory.nextBool() ? "H" : "T";
                      }),
                      DiceButton(label: "D4", iconData: CongregaIcons.dice_d4, callback: () {
                        Random randFactory = Random(DateTime.now().second);
                        return (randFactory.nextInt(4) + 1).toString();
                      }),
                      DiceButton(label: "D6", iconData: CongregaIcons.dice_d6, callback: ()  {
                        Random randFactory = Random(DateTime.now().second);
                        return (randFactory.nextInt(6) + 1).toString();
                      }),
                    ]
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Row(
                    children: [
                      DiceButton(label: "D10", iconData: CongregaIcons.dice_d10, callback: () {
                        Random randFactory = Random(DateTime.now().second);
                        return (randFactory.nextInt(10) + 1).toString();
                      }),
                      DiceButton(label: "D12", iconData: CongregaIcons.dice_d12, callback: () {
                        Random randFactory = Random(DateTime.now().second);
                        return (randFactory.nextInt(12) + 1).toString();
                      }),
                      DiceButton(label: "D20", iconData: CongregaIcons.dice_d20, callback: ()  {
                        Random randFactory = Random(DateTime.now().second);
                        return (randFactory.nextInt(20) + 1).toString();
                      }),
                    ]
                ),
              ),
            ]
        )
    );
  }

}