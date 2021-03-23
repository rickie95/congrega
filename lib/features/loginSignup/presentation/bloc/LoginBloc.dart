import 'dart:async';
import 'dart:io';
import 'package:congrega/authentication/AuthenticationRepository.dart';
import 'package:congrega/features/loginSignup/model/UserCredentials.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'LoginState.dart';
import 'LoginEvent.dart';
import '../forms/inputs/PasswordFormInput.dart';
import '../forms/inputs/UsernameFormInput.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({ required this.authenticationRepository }) : super(const LoginState());

  final AuthenticationRepository authenticationRepository;

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

        await authenticationRepository.logIn(user:
          UserCredentials(
              username: state.username.value,
              password: state.password.value
          )
        );

        yield state.copyWith(status: FormzStatus.submissionSuccess);
      } on Exception catch (e) {
        debugPrint(e.toString());
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }
}

