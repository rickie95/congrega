import 'package:congrega/model/User.dart';
import 'package:congrega/user/UserRepository.dart';

class UserController {

  const UserController({this.repo});
  
  final UserRepository repo;
  
  User getLoggedUser(){
    return repo.getUser();
  }
  
}