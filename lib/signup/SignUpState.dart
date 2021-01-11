import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../forms/inputs/NameFormInput.dart';
import '../forms/inputs/PasswordFormInput.dart';
import '../forms/inputs/UsernameFormInput.dart';

class SignUpState extends Equatable {
  const SignUpState({
    this.status = FormzStatus.pure,
    this.name = const NameFormInput.pure(),
    this.username = const UsernameFormInput.pure(),
    this.password = const PasswordFormInput.pure(),
    this.passwordVisible = false,
  });

  final FormzStatus status;
  final NameFormInput name;
  final UsernameFormInput username;
  final PasswordFormInput password;
  final bool passwordVisible;

  SignUpState copyWith({
    FormzStatus status,
    NameFormInput name,
    UsernameFormInput username,
    PasswordFormInput password,
    bool passwordVisible,
  }) {
    return SignUpState(
      status: status ?? this.status,
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
      passwordVisible: passwordVisible ?? this.passwordVisible
    );
  }

  @override
  List<Object> get props => [status, name, username, password, passwordVisible];
}
