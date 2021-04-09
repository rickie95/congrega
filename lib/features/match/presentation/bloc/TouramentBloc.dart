import 'package:congrega/features/match/presentation/bloc/TournamentEvent.dart';
import 'package:congrega/features/match/presentation/bloc/TournamentState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TournamentBloc extends Bloc<TournamentEvent, TournamentState> {
  TournamentBloc() : super(InitialTournamentState());

  @override
  Stream<TournamentState> mapEventToState(TournamentEvent event) {
    throw UnimplementedError();
  }


}