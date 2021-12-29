import 'dart:async';
import 'dart:convert';

import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Maintain a simple list of users. Everything is saved locally.
class FriendRepository {
  static const FRIENDS_LIST = "FRIENDS_LIST";

  static List<User> _friends = [];

  final FlutterSecureStorage secureStorage;

  /// Initialize and create a [FriendRepository]
  FriendRepository({required this.secureStorage}) {
    _loadFriendList();
  }

  /// Adds an [User] as a friend, stored in the static collection, then
  /// persisted in local storage.
  void addFriend(User friend) {
    _friends.add(friend);
    this._updateFriendList();
  }

  /// Removes an [User] from the collection
  void removeFriend(User friend) {
    _friends.remove(friend);
    this._updateFriendList();
  }

  bool isEmpty() {
    return _friends.isEmpty;
  }

  Future<List<User>> fetchFriendsList() {
    return _loadFriendList();
  }

  List<User> getFriendsList() {
    return _friends;
  }

  Future<void> _updateFriendList() async {
    secureStorage.write(key: FRIENDS_LIST, value: jsonEncode(_friends));
  }

  Future<List<User>> _loadFriendList() async {
    String? encodedList = await secureStorage.read(key: FRIENDS_LIST);
    if (encodedList == null || encodedList.isEmpty) {
      _friends = [];
    } else {
      _friends = User.decodeUserList(jsonDecode(encodedList) as List<Object?>).toList();
    }
    return _friends;
  }

  Future<List<User>> searchByUsername(String username) {
    return Future.delayed(
        Duration(milliseconds: 200),
        () => _friends
            .where((user) => user.username.toLowerCase().contains(username.toLowerCase()))
            .toList());
  }

  bool isFriendWith(User user) {
    return _friends.contains(user);
  }
}
