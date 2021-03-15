import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginUsernameChanged extends LoginEvent {
  const LoginUsernameChanged(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}

class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class LoginPasswordVisibilityChanged extends LoginEvent {
  const LoginPasswordVisibilityChanged(this.visibility);

  final bool visibility;

  @override
  List<Object> get props => [visibility];
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}
