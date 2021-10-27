import 'package:equatable/equatable.dart';

class FriendsWidgetState extends Equatable {
  final int listLength;

  FriendsWidgetState({required this.listLength});

  @override
  List<Object?> get props => [listLength];
}
