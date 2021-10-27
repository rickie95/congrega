import 'package:congrega/features/dashboard/presentation/widgets/friends_widget/bloc/friends_widget_events.dart';
import 'package:congrega/features/dashboard/presentation/widgets/friends_widget/bloc/friends_widget_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FriendsWidgetBloc extends Bloc<FriendsWidgetEvent, FriendsWidgetState> {
  FriendsWidgetBloc() : super(new FriendsWidgetState(listLength: 0));

  @override
  Stream<FriendsWidgetState> mapEventToState(FriendsWidgetEvent event) async* {
    if (event is FriendListUpdated)
      yield new FriendsWidgetState(listLength: event.listLenght);

    yield new FriendsWidgetState(listLength: 0);
  }
}
