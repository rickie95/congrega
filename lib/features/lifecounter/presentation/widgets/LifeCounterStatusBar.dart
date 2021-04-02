import 'package:congrega/features/match/presentation/bloc/MatchBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'LifeCounterModalBottomSheet.dart';
import 'matchScoreWidget/MatchScoreModalBottomSheet.dart';
import 'matchScoreWidget/MatchScoreWidget.dart';
import '../../timeWidgets/presentation/widgets/TimeWidget.dart';
import '../bloc/GameBloc.dart';
import '../bloc/GameState.dart';

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
          Expanded(flex: 33,
            child: TimeWidget(),
          ),


          // Score
          Expanded(flex: 33,
            // child: Text("Status BAr"),
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
          Expanded(flex: 33,
              child: OptionButton()
          )
        ],
      ),
    );
  }
}



class OptionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
        builder: (context, GameState state){
          return GestureDetector(
              onTap: () {
                showModalBottomSheet<void>(context: context,
                    builder: (_) {
                      return BlocProvider.value(
                          value: BlocProvider.of<GameBloc>(context),
                          child: LifeCounterModalBottomSheet());
                    });
              },
              child: Container(
                child:  Center(child: Icon(Icons.settings, size: 30,),),
              )
          );
        });
  }
}