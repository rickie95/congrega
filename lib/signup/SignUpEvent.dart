import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpNameChanged extends SignUpEvent {
  const SignUpNameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class SignUpUsernameChanged extends SignUpEvent {
  const SignUpUsernameChanged(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}

class SignUpPasswordChanged extends SignUpEvent {
  const SignUpPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class SignUpPasswordVisibilityChanged extends SignUpEvent {
  const SignUpPasswordVisibilityChanged(this.isPasswordVisible);

  final bool isPasswordVisible;

  @override
  List<Object> get props => [isPasswordVisible];
}

class SignUpSubmitted extends SignUpEvent {
  const SignUpSubmitted();
}