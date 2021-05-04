
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';

import 'injector.dart';

void main() {
  runApp(ValueView());
}

class ValueView extends StatefulWidget {
  @override
  _ValueViewState createState() => _ValueViewState();
}

class _ValueViewState extends State<ValueView> {

  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState? get _navigator => _navigatorKey.currentState;

  @override
  void initState() {
    super.initState();
    DepInj.setup();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      home: InitialPage(),
    );
  }

}

class InitialPage extends StatelessWidget {

  static MaterialPageRoute route() => MaterialPageRoute(builder: (_) => InitialPage());

  const InitialPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider.value(
          value: KiwiContainer().resolve<ValueBloc>(),
          child: BodyWidget(),
        ),
      ),
    );
  }
}

class BodyWidget extends StatelessWidget {
  const BodyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () => BlocProvider.of<ValueBloc>(context).add(SetValue(1)),
            child: Text("1")
        ),
        ElevatedButton(
            onPressed: () => BlocProvider.of<ValueBloc>(context).add(SetValue(2)),
            child: Text("2")
        ),
        ElevatedButton(
            onPressed: () => Navigator.of(context).push(NextPage.route()), child: Text("next")
        )
      ],
    );
  }
}

class NextPage extends StatelessWidget {

  static MaterialPageRoute route() {
    return MaterialPageRoute(builder: (_) => NextPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider.value(
          value: KiwiContainer().resolve<ValueBloc>(),
          child: Center(
            child: BlocBuilder<ValueBloc, ValueState>(
              builder: (context, state) => Text(state.value.toString()),
            ),
          ),
        ),
      ),
    );
  }

}

class ValueBloc extends Bloc<ValueEvents, ValueState> {
  ValueBloc() : super(const ValueState.unknown());

  @override
  Stream<ValueState> mapEventToState(ValueEvents event) async* {
    if(event is SetValue){
      yield state.copyWith(value: event.newValue);
    } else {
      yield ValueState.unknown();
    }
  }

}

class ValueState extends Equatable {

  final int value;

  const ValueState({required this.value});
  const ValueState.unknown() : this.value = 0;

  ValueState copyWith({int? value}){
    return ValueState(
        value: value ?? this.value
    );
  }

  @override
  List<Object?> get props => [value];
}

class ValueEvents extends Equatable {
  const ValueEvents();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class SetValue extends ValueEvents{
  const SetValue(this.newValue);

  final int newValue;

  @override
  List<Object?> get props => [newValue];
}