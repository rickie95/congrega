import 'package:congrega/features/lifecounter/presentation/widgets/timeWidgets/bloc/TimeSettingsBloc.dart';
import 'package:congrega/features/lifecounter/presentation/widgets/timeWidgets/bloc/TimeSettingsEvent.dart';
import 'package:congrega/features/lifecounter/presentation/widgets/timeWidgets/bloc/TimeSettingsState.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BaseTimeWidget extends StatefulWidget {
  @override
  BaseTimeWidgetState createState() => BaseTimeWidgetState();
}

class BaseTimeWidgetState extends State<BaseTimeWidget> {

  late String minutes;
  late String seconds;

  void reset() {}
  void pause() {}
  void run() {}

  Widget buildText(BuildContext context){
    return Text("$minutes:$seconds", style: TextStyle(fontSize: 25),);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TimeSettingsBloc, TimeSettingsState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if(state.status == TimeWidgetStatus.paused) {
          this.pause();
        } else if( state.status == TimeWidgetStatus.stopped){
          this.reset();
          context.read<TimeSettingsBloc>().add(TimeWidgetResumed());
        } else {
          this.run();
          context.read<TimeSettingsBloc>().add(TimeWidgetResumed());
        }
      },
      child: buildText(context),
    );
  }

}