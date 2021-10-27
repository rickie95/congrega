import 'package:congrega/features/lifecounter/presentation/bloc/match/MatchBloc.dart';
import 'package:congrega/features/lifecounter/presentation/widgets/timeWidgets/widgets/TimeWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../congrega_icons.dart';
import 'dicePage/DicePage.dart';
import 'matchScoreWidget/MatchScoreModalBottomSheet.dart';
import 'matchScoreWidget/MatchScoreWidget.dart';
import '../bloc/LifeCounterBloc.dart';
import '../bloc/LifeCounterState.dart';

class StatusBar extends StatelessWidget {
  const StatusBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          // Time Widget
          Expanded(flex: 33, child: TimeWidget()),

          // Score
          Expanded(flex: 33,
            child: GestureDetector(
                onTap: () => showModalBottomSheet<void>(
                    context: context,
                    builder: (_) {
                      return BlocProvider.value(
                          value: BlocProvider.of<MatchBloc>(context),
                          child: MatchScoreModalBottomSheet());
                    }
                ),
                child: Container(
                  child: Center(
                      child: MatchScoreWidget()
                  ),
                )
            ),
          ),

          // Option Button
          Expanded(flex: 33, child: DicePageButton()),
        ],
      ),
    );
  }
}

class DicePageButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LifeCounterBloc, LifeCounterState>(
        builder: (context, LifeCounterState state){
          return IconButton(
            onPressed: () => showDicePage(context),
            icon: Icon(CongregaIcons.dice_d20, size: 30),
          );
        });
  }
}
