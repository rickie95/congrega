
import 'package:congrega/forms/inputs/NameFormInput.dart';
import 'package:congrega/forms/inputs/UsernameFormInput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

import 'SignUpEvent.dart';
import 'SignUpState.dart';
import '../forms/inputs/PasswordFormInput.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({ @required SignUpService signUpService}) : 
      assert(signUpService != null),
      _signUpService = signUpService,
      super(const SignUpState());

  final SignUpService _signUpService;
  
  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is SignUpNameChanged){
      yield _mapNameChangedToState(event, state);
    } else if (event is SignUpUsernameChanged) {
      yield _mapUsernameChangedToState(event, state);
    } else if (event is SignUpPasswordChanged) {
      yield _mapPasswordChangedToState(event, state);
    } else if (event is SignUpPasswordVisibilityChanged) {
      yield _mapPasswordVisibilityChangedToState(event, state);
    } else if (event is SignUpSubmitted) {
      yield* _mapSignUpSubmittedToState(event, state);
    }
  }
  
  SignUpState _mapNameChangedToState(SignUpNameChanged event, SignUpState state){
    final name = NameFormInput.dirty(event.name);
    return state.copyWith(
      name: name,
      status: Formz.validate([name, state.username, state.password])
    );
  }

  SignUpState _mapUsernameChangedToState(SignUpUsernameChanged event, SignUpState state){
    final username = UsernameFormInput.dirty(event.username);
    return state.copyWith(
        username: username,
        status: Formz.validate([state.name, username, state.password])
    );
  }

  SignUpState _mapPasswordChangedToState(SignUpPasswordChanged event, SignUpState state){
    final password = PasswordFormInput.dirty(event.password);
    return state.copyWith(
        password: password,
        status: Formz.validate([state.name, state.username, password])
    );
  }

  SignUpState _mapPasswordVisibilityChangedToState(SignUpPasswordVisibilityChanged event, SignUpState state) {
    final passwordVisibility = event.isPasswordVisible;
    return state.copyWith(
        passwordVisible: passwordVisibility );
  }

  Stream<SignUpState> _mapSignUpSubmittedToState(SignUpSubmitted event, SignUpState state) async* {
    debugPrint(state.toString());
    if(state.status.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        await _signUpService.signUp(
          name: state.name.value,
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


class SignUpService {

  Future<void> signUp({ @required String name,
                        @required String username,
                        @required String password,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 300),
          () => debugPrint("Sent sign up request"),
    );
  }

}