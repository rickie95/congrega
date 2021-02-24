import 'package:congrega/model/User.dart';

class UserRepository {

  User getUser() {
    User user = new User(
        id: BigInt.two
    );
    return user;
  }
}