import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:http/http.dart' as http;

class FriendClient {
  final http.Client httpClient;

  FriendClient({required this.httpClient});

  Future<User> getUserByUsername(String username) async {
    return Future.delayed(Duration(seconds: 1), () => User.empty);
  }
}
