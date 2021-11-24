import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:congrega/features/lifecounter/model/PlayerPoints.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/LifeCounterBloc.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/LifeCounterEvents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlayerCountersSettings extends StatelessWidget {
  const PlayerCountersSettings({
    Key? key,
    required this.player,
  }) : super(key: key);

  final Player player;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: new List.generate(
              PlayerPoints.playerCountersTypes.length, (index) =>
              CounterSwitchTile(
                title: _getPointsToString(context, PlayerPoints.playerCountersTypes[index]),
                // title: PlayerPoints.playerCountersTypes[index].readableName(),
                leading: Icon(Icons.visibility),
                initialValue: player.hasPointsOfType(
                    PlayerPoints.playerCountersTypes[index]),
                onToggle: (bool toggle) {
                  toggle ?
                  context.read<LifeCounterBloc>().add(
                      GamePlayerPointsAdded(player,
                          PlayerPoints.getInstanceOf(
                              PlayerPoints.playerCountersTypes[index]))) :
                  context.read<LifeCounterBloc>().add(
                      GamePlayerPointsRemoved(player,
                          PlayerPoints.getInstanceOf(
                              PlayerPoints.playerCountersTypes[index])));
                },
              )
          ),
        )
    );
  }

  String _getPointsToString(BuildContext context, Type playerCountersType) {
    if (playerCountersType == PlayerPoints.playerCountersTypes[0]) {
      return AppLocalizations.of(context)!.venom_points_name; //AppLocalizations.of(context)!.energy_points_name
    } else if (playerCountersType == PlayerPoints.playerCountersTypes[1]) {
      return AppLocalizations.of(context)!.energy_points_name;
    } else if (playerCountersType == PlayerPoints.playerCountersTypes[2]) {
      return AppLocalizations.of(context)!.mana_color_points_name;
    } else {
      return "Unknown(?)";
    }
  }
}

class CounterSwitchTile extends StatelessWidget {

  static const Color textColor = Colors.white;
  static const TextStyle switchTileTextStyle = TextStyle(fontSize: 17, color: textColor);

  final Widget leading;
  final String title;
  final bool initialValue;
  final Function(bool) onToggle;

  const CounterSwitchTile({
    required this.leading,
    required this.title,
    required this.initialValue,
    required this.onToggle
});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(flex: 15, child: leading),
          Expanded(flex: 70, child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(title, style: switchTileTextStyle,),
          )),
          Expanded(flex: 15, child: Switch(
            activeColor: Colors.orange,
            value: initialValue,
            onChanged: onToggle,
          )),
        ],
      ),
    );
  }

}




