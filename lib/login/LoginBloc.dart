import 'dart:async';
import 'package:congrega/authentication/AuthenticationService.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'LoginState.dart';
import 'LoginEvent.dart';
import '../forms/inputs/PasswordFormInput.dart';
import '../forms/inputs/UsernameFormInput.dart';



class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    @required AuthenticationService authenticationRepository,
  })  : assert(authenticationRepository != null),
        _authenticationService = authenticationRepository,
        super(const LoginState());

  final AuthenticationService _authenticationService;

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginUsernameChanged) {
      yield _mapUsernameChangedToState(event, state);
    } else if (event is LoginPasswordChanged) {
      yield _mapPasswordChangedToState(event, state);
    } else if (event is LoginPasswordVisibilityChanged){
      yield _mapPasswordVisibilityChangedToState(event, state);
    } else if (event is LoginSubmitted) {
      yield* _mapLoginSubmittedToState(event, state);
    }
  }

  LoginState _mapUsernameChangedToState(LoginUsernameChanged event, LoginState state) {
    final username = UsernameFormInput.dirty(event.username);
    return state.copyWith(
      username: username,
      status: Formz.validate([state.password, username]),
    );
  }

  LoginState _mapPasswordChangedToState(LoginPasswordChanged event, LoginState state) {
    final password = PasswordFormInput.dirty(event.password);
    return state.copyWith(
      password: password,
      status: Formz.validate([password, state.username]),
    );
  }

  LoginState _mapPasswordVisibilityChangedToState(LoginPasswordVisibilityChanged event, LoginState state){
    final visibility = event.visibility;
    return state.copyWith( passwordVisibility: visibility );
  }

  Stream<LoginState> _mapLoginSubmittedToState(LoginSubmitted event, LoginState state) async* {
    if (state.status.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        await _authenticationService.logIn(
          username: state.username.value,
          password: state.password.value,
        );
        yield state.copyWith(status: FormzStatus.submissionSuccess);
      } on Exception catch (_) {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }
}
