import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:congrega/features/lifecounter/model/PlayerPoints.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/LifeCounterBloc.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/LifeCounterEvents.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerPointsWidget extends StatelessWidget {
  const PlayerPointsWidget({
    required this.pointSectionBlocBuilder,
    required this.settingsBlocBuilder,
    required this.backgroundColor,
    required this.playerName,
  }) : super();

  final BlocBuilder pointSectionBlocBuilder;
  final BlocBuilder settingsBlocBuilder;
  final Color backgroundColor;
  final String playerName;

  @override
  Widget build(BuildContext context) {
    // Column is rebuilt whenever the points list change its size
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
          child: Material(
            elevation: 14,
            color: backgroundColor,
            shadowColor:  Colors.black,
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
                child: pointSectionBlocBuilder
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: FloatingActionButton(
            heroTag: '$playerName-SettingFloatingButton',
            elevation: 14,
            child: Icon(Icons.settings),
            onPressed: () => showModalBottomSheet(context: context, builder: (_) => BlocProvider.value(
              value: BlocProvider.of<LifeCounterBloc>(context),
              child: settingsBlocBuilder,
            ),
            ),
          ),
        ),
      ],
    );
  }
}

class PlayerPointRow extends StatelessWidget {
  const PlayerPointRow({required this.player, required this.points}) : super();

  final Player player;
  final PlayerPoints points;

  @override
  Widget build(BuildContext context) {

    var leftAnimatedColorContainer = ColorAnimatedContainer();
    var rightColorAnimatedContainer = ColorAnimatedContainer();

    return Stack(
        children: [

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Text(points.value.toString(), style: TextStyle(fontSize: 45))
              ),
              const Padding(padding: EdgeInsets.all(2)),
              Center(
                child: Icon(
                  getIconForPoints(points),
                  size: 20,
                ),
              )
            ],
          ),

          Row(
            children: [
              Expanded(
                  flex: 50,
                  child: Stack(
                    children: [
                      ColorAnimatedContainer(),
                      GestureDetector(
                        onTap: () => context.read<LifeCounterBloc>().add(
                            GamePlayerPointsChanged(
                                player, points.copyWith(points.value - 1))
                        ),
                      ),
                    ],
                  ),
              ),

              Expanded(
                flex: 50,
                child: Stack(
                  children: [
                    ColorAnimatedContainer(),
                    GestureDetector(
                      onTap: () => context.read<LifeCounterBloc>().add(
                          GamePlayerPointsChanged(
                              player, points.copyWith(points.value + 1))
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ]
    );
  }

  IconData getIconForPoints(PlayerPoints points) {
    if (points is LifePoints) {
      return Icons.favorite;
    } else if (points is VenomPoints) {
      return Icons.visibility;
    } else if (points is EnergyPoints) {
      return Icons.flash_on;
    }

    return Icons.whatshot;
  }
}

class ColorAnimatedContainer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ColorAnimatedContainer();
}

class _ColorAnimatedContainer extends State<ColorAnimatedContainer> with SingleTickerProviderStateMixin {

  late Animation<Color?> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 150), vsync: this);
    _animation = ColorTween(begin: Colors.transparent, end: Color.fromRGBO(0, 0, 0, 0.3)).animate(_controller)
      ..addListener(() {setState(() {});});
  }

  void animateColor() => _controller.forward().then((value) => _controller.reverse());

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (_) => animateColor(),
      child: AnimatedContainer(
        color: _animation.value,
        duration: Duration(milliseconds: 350),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

}

class ChangePointsValueButton extends StatefulWidget {
  ChangePointsValueButton({required this.callback});

  Function() callback;

  @override
  _ChangePointsValueButtonState createState() => _ChangePointsValueButtonState(callback: callback);
}

class _ChangePointsValueButtonState extends State<ChangePointsValueButton> with SingleTickerProviderStateMixin {
  _ChangePointsValueButtonState({required this.callback});

  late Animation<Color?> _animation;
  late AnimationController _controller;
  Function() callback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (_) => animateColor(),
        onTap: () => callback(),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color : _animation.value,
          ),
          child: Center(
            child: Icon(
              Icons.remove,
              size: 20,
            ),
          ),
        )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 150), vsync: this);
    _animation = ColorTween(begin: Colors.transparent, end: Color.fromRGBO(0, 0, 0, 0.3)).animate(_controller)
      ..addListener(() {setState(() {

      });});
  }

  void animateColor() {
    _controller.forward().then((value) => _controller.reverse());
  }
}


List<Widget> getPointRows(BuildContext context, Player player){
  return new List.generate(player.points.length, (int index){
    return new Expanded(
        flex: (index==0 ? mainFlex[player.points.length] : secondaryFlex[player.points.length])!,
        child: PlayerPointRow(player: player, points: player.points.elementAt(index))
    );
  });
}

const Map<int, int> mainFlex = {
  1 : 100,
  2 : 60,
  3 : 40,
  4 : 30,
  5 : 20
};
const Map<int, int> secondaryFlex = {
  2 : 40,
  3 : 30,
  4 : 23,
  5 : 20
};