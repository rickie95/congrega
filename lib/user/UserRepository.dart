import 'package:congrega/httpClients/UserHttpClient.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class UserRepository {

  UserRepository({required this.userHttpClient});

  final UserHttpClient userHttpClient;

  List<User>? getUserList() {
    userHttpClient.getUserList()
        .then((value) => value);
  }

  Future<User?> getUser() {
    User user = new User(
        id: '1',
      username: "Me"
    );
    return Future.delayed(new Duration(seconds: 1), () => user);
  }
}