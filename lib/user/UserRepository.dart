import 'package:congrega/httpClients/UserHttpClient.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:http/http.dart' as http;

class UserRepository {

  UserRepository() :
      userHttpClient = new UserHttpClient(new http.Client());

  final UserHttpClient userHttpClient;

  List<User>? getUserList() {
    userHttpClient.getUserList()
        .then((value) => value);
  }

  User getUser() {
    User user = new User(
        id: BigInt.two,
      username: "Me"
    );
    return user;
  }
}