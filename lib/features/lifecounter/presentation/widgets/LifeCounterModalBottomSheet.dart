import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:congrega/features/lifecounter/model/PlayerPoints.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/LifeCounterBloc.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/LifeCounterEvents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_ui/settings_ui.dart';

class PlayerSettingsModalBottomSheet extends StatelessWidget {
  const PlayerSettingsModalBottomSheet({
    Key? key,
    required this.player,
  }) : super(key: key);

  final String _sectionTitle = "Counters settings";
  final Player player;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SettingsList(
        backgroundColor: Colors.white,
        sections: [
          SettingsSection(
            title: _sectionTitle,
            titleTextStyle: TextStyle(fontSize: 16, color: Color.fromRGBO(0, 0, 0, 0.54)),
            tiles: new List.generate(PlayerPoints.playerCountersTypes.length, (index) =>
                SettingsTile.switchTile(
                  title: PlayerPoints.playerCountersTypes[index].toString(),
                  leading: Icon(Icons.visibility),
                  switchValue: player.hasPointsOfType(PlayerPoints.playerCountersTypes[index]),
                  onToggle: (bool toggle) {
                    toggle ?
                    context.read<LifeCounterBloc>().add(GamePlayerPointsAdded(player,
                        PlayerPoints.getInstanceOf(PlayerPoints.playerCountersTypes[index]))) :
                    context.read<LifeCounterBloc>().add(GamePlayerPointsRemoved(player,
                        PlayerPoints.getInstanceOf(PlayerPoints.playerCountersTypes[index])));
                  },
                )
            ),
          ),
        ],
      ),
    );
  }
}




