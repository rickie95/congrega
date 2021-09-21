import 'package:equatable/equatable.dart';

class FriendsWidgetEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class FriendListUpdated extends FriendsWidgetEvent {
  final int listLenght;

  FriendListUpdated({required this.listLenght});

  @override
  List<Object?> get props => [listLenght];
}
