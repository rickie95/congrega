import 'package:formz/formz.dart';
import 'package:equatable/equatable.dart';

import '../forms/inputs/PasswordFormInput.dart';
import '../forms/inputs/UsernameFormInput.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = FormzStatus.pure,
    this.username = const UsernameFormInput.pure(),
    this.password = const PasswordFormInput.pure(),
    this.passwordVisibility = false,
    this.errorMessage = ''
  });

  final FormzStatus status;
  final UsernameFormInput username;
  final PasswordFormInput password;
  final bool passwordVisibility;
  final String errorMessage;

  LoginState copyWith({ FormzStatus? status, UsernameFormInput? username,
    PasswordFormInput? password, bool? passwordVisibility, String? errorMessage}) {
    return LoginState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      passwordVisibility: passwordVisibility ?? this.passwordVisibility,
      errorMessage: errorMessage ?? this.errorMessage
    );
  }

  @override
  List<Object> get props => [status, username, password, passwordVisibility];
}
