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
  }) : super();

  final BlocBuilder pointSectionBlocBuilder;
  final BlocBuilder? settingsBlocBuilder;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    // Column is rebuilt whenever the points list change its size
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
      child: Stack(
        children: [
          settingsBlocBuilder != null
              ? Container(
                  decoration: BoxDecoration(
                      color: Colors.black87, borderRadius: BorderRadius.circular(12.0)),
                  child: settingsBlocBuilder,
                )
              : Container(),
          SlidableWidget(
            slidable: settingsBlocBuilder != null,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Material(
                  elevation: 14,
                  color: backgroundColor,
                  shadowColor: Colors.black,
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(child: pointSectionBlocBuilder),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.black87,
                    ),
                    height: 5,
                    width: 20,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SlidableWidget extends StatefulWidget {
  const SlidableWidget({
    Key? key,
    required this.child,
    required this.slidable,
  }) : super(key: key);

  final Widget child;
  final bool slidable;

  @override
  State<StatefulWidget> createState() => _SlidableWidgetState();
}

class _SlidableWidgetState extends State<SlidableWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller = AnimationController(vsync: this, upperBound: 0.85);
  double _dragExtent = 0;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => SlideTransition(
        position: AlwaysStoppedAnimation(Offset(0, _controller.value)),
        child: GestureDetector(
          onVerticalDragStart: widget.slidable ? _onDragStart : null,
          onVerticalDragUpdate: widget.slidable ? _onDragUpdate : null,
          onVerticalDragEnd: widget.slidable ? _onDragEnd : null,
          child: widget.child,
        ),
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    setState(() {
      _dragExtent = _controller.value * context.size!.height;
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    _dragExtent += (details.primaryDelta ?? 0);
    setState(() {
      _controller.value = _dragExtent / context.size!.height;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    _controller.value > 0.4 ? _controller.fling() : _controller.fling(velocity: -1.0);
    setState(() {
      _dragExtent = 0;
    });
  }
}

class PlayerPointRow extends StatelessWidget {
  const PlayerPointRow({required this.player, required this.points}) : super();

  final Player player;
  final PlayerPoints points;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text(points.value.toString(), style: TextStyle(fontSize: 45))),
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
                  onTap: () => context
                      .read<LifeCounterBloc>()
                      .add(GamePlayerPointsChanged(player, points.copyWith(points.value - 1))),
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
                  onTap: () => context
                      .read<LifeCounterBloc>()
                      .add(GamePlayerPointsChanged(player, points.copyWith(points.value + 1))),
                ),
              ],
            ),
          ),
        ],
      )
    ]);
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

class _ColorAnimatedContainer extends State<ColorAnimatedContainer>
    with SingleTickerProviderStateMixin {
  late Animation<Color?> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 150), vsync: this);
    _animation = ColorTween(begin: Colors.transparent, end: Color.fromRGBO(0, 0, 0, 0.3))
        .animate(_controller)
          ..addListener(() {
            setState(() {});
          });
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

List<Widget> getPointRows(BuildContext context, Player player) {
  return new List.generate(player.points.length, (int index) {
    return new Expanded(
        flex: (index == 0 ? mainFlex[player.points.length] : secondaryFlex[player.points.length])!,
        child: PlayerPointRow(player: player, points: player.points.elementAt(index)));
  });
}

const Map<int, int> mainFlex = {1: 100, 2: 60, 3: 40, 4: 30, 5: 20};
const Map<int, int> secondaryFlex = {2: 40, 3: 30, 4: 23, 5: 20};
