import 'package:equatable/equatable.dart';

class UserCredentials extends Equatable {
  
  final String username;
  final String password;
  final String? name;
  
  const UserCredentials({
    required this.username,
    required this.password,
    this.name
  });

  @override
  List<Object> get props => [username, password];
  
}