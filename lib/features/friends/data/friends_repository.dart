import 'dart:convert';

import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Maintain a simple list of users. Everything is saved locally.
class FriendRepository {
  static const FRIENDS_LIST = "FRIENDS_LIST";

  static List<User> _friends = [
    new User(id: "001", name: "Frank", username: "frankieHINRG"),
    new User(id: "002", name: "Rodrigo", username: "donRodrigo"),
    new User(id: "003", name: "John Wick", username: "babaYaga"),
    new User(id: "004", name: "Mike Tyson", username: "mikeTheBite")
  ];

  final FlutterSecureStorage secureStorage;

  /// Initialize and create a [FriendRepository]
  FriendRepository({required this.secureStorage}) {
    //_loadFriendList();
  }

  /// Adds an [User] as a friend, stored in the static collection, then
  /// persisted in local storage.
  void addFriend(User friend) {
    _friends.add(friend);
    //this._updateFriendList(friend);
  }

  List<User> getFriendsList() {
    return _friends;
  }

  Future<void> _updateFriendList(User friend) async {
    secureStorage.write(key: FRIENDS_LIST, value: jsonEncode(_friends));
  }

  Future<void> _loadFriendList() async {
    String? encodedList = await secureStorage.read(key: FRIENDS_LIST);
    if (encodedList == null || encodedList.isEmpty) {
      _friends = [];
    } else {
      _friends = User.decodeUserList(encodedList as List<Object?>).toList();
    }
  }
}
