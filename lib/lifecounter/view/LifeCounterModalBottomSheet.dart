import 'package:congrega/lifecounter/GameEvents.dart';
import 'package:congrega/lifecounter/model/Player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_ui/settings_ui.dart';

import '../GameBloc.dart';
import '../GameState.dart';

class LifeCounterModalBottomSheet extends StatelessWidget {

  final String _sectionTitle = "Counters settings";

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 10),
        child: _body(context)
    );
  }

  Widget _body(BuildContext context){
    return BlocBuilder<GameBloc, GameState>(
        buildWhen: (previous, current) => (previous.user.points != current.user.points),
        builder: (context, state) {
          return SettingsList(
            backgroundColor: Colors.white,
            sections: [
              SettingsSection(
                title: _sectionTitle,
                titleTextStyle: TextStyle(fontSize: 16, color: Color.fromRGBO(0, 0, 0, 0.54)),
                tiles: new List.generate(PlayerPoints.playerCountersTypes.length, (index) =>
                    SettingsTile.switchTile(
                      title: PlayerPoints.playerCountersTypes[index].toString(),
                      leading: Icon(Icons.visibility),
                      switchValue: state.user.hasPointsOfType(PlayerPoints.playerCountersTypes[index]),
                      onToggle: (bool toggle) {
                        toggle ?
                        context.read<GameBloc>().add(GamePlayerPointsAdded(state.user,
                            PlayerPoints.getInstanceOf(PlayerPoints.playerCountersTypes[index]))) :
                        context.read<GameBloc>().add(GamePlayerPointsRemoved(state.user,
                            PlayerPoints.getInstanceOf(PlayerPoints.playerCountersTypes[index])));
                      },
                    )
                ),
              ),
            ],
          );
        }
    );
  }

  Widget _upperRow(BuildContext context){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(flex: 20, child:  Container()),

        Expanded(flex: 60,child: Center( child: Text("Match Settings"))),

        Expanded(flex: 20,child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_downward),
        ))
      ],
    );
  }

}




