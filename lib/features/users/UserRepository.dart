import 'package:congrega/features/loginSignup/model/UserCredentials.dart';
import 'package:congrega/features/users/UserHttpClient.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserRepository {
  static const String USERNAME_KEY = 'account_username';
  static const String PASSWORD_KEY = 'account_password';
  static const String NAME_KEY = 'account_name';
  static const String ID_KEY = 'account_id';

  UserRepository({required this.userHttpClient, required this.secureStorage});

  final UserHttpClient userHttpClient;
  final FlutterSecureStorage secureStorage;

  List<User>? getUserList() {
    userHttpClient.getUserList().then((value) => value);
  }

  Future<User?> getUserById(String id) {
    return userHttpClient.getUserById(id);
  }

  Future<User> getUser() async {
    return User(
        id: await getValueFromKey(ID_KEY),
        name: await getValueFromKey(NAME_KEY),
        username: await getValueFromKey(USERNAME_KEY),
        password: await getValueFromKey(PASSWORD_KEY));
  }

  Future<String> getValueFromKey(String key) async {
    return await secureStorage.read(key: key).onError((error, stackTrace) => throw Error()) ?? '';
  }

  Future<void> saveUserAccountInfo(User user) async {
    try {
      secureStorage.write(key: USERNAME_KEY, value: user.username);
      secureStorage.write(key: PASSWORD_KEY, value: user.password);
      secureStorage.write(key: NAME_KEY, value: user.name);
      secureStorage.write(key: ID_KEY, value: user.id);
    } catch (ex) {
      // 'Error occurred while saving account info on device.'
      print('Error occurred while saving account info on device.' + ex.toString());
      throw Error();
    }
  }

  static User getEmptyUser() {
    return User.empty;
  }

  Future<void> saveUserInfo(UserCredentials user) async {
    User userInfo;
    try {
      userInfo = await userHttpClient.getUserByUsername(user.username);
      userInfo = userInfo.copyWith(password: user.password);
    } catch (error) {
      print(error.toString());
      userInfo = User(
          id: '-',
          username: user.username,
          password: user.password,
          name: user.name ?? user.username);
    }

    print(userInfo);
    saveUserAccountInfo(userInfo);
  }

  Future<List<User>> searchByUsername(String username) {
    return userHttpClient.searchByUsername(username);
  }
}
