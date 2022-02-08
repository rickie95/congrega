import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:congrega/features/loginSignup/model/User.dart';

import 'package:congrega/features/users/UserRepository.dart';

import 'AuthenticationState.dart';
import 'AuthenticationEvent.dart';
import 'AuthenticationRepository.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required this.authenticationRepository,
    required this.userRepository,
  }) : super(const AuthenticationState.unknown()) {
    _authenticationStatusSubscription = authenticationRepository.status.listen(
      (status) => add(AuthenticationStatusChanged(status)),
    );
  }

  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;
  late StreamSubscription<AuthenticationStatus> _authenticationStatusSubscription;

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AuthenticationStatusChanged) {
      yield await _mapAuthenticationStatusChangedToState(event);
    } else if (event is AuthenticationLoginRequested) {
      authenticationRepository.logInCurrentUser();
    } else if (event is AuthenticationLogoutRequested) {
      authenticationRepository.logOut();
    }
  }

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    authenticationRepository.dispose();
    return super.close();
  }

  Future<AuthenticationState> _mapAuthenticationStatusChangedToState(
      AuthenticationStatusChanged event) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return const AuthenticationState.unauthenticated();
      case AuthenticationStatus.authenticated:
        final user = await _tryGetUser();
        return user != null
            ? AuthenticationState.authenticated(user)
            : const AuthenticationState.unauthenticated();
      default:
        return const AuthenticationState.unknown();
    }
  }

  Future<User?> _tryGetUser() async {
    try {
      return await userRepository.getUser();
    } on Exception {
      return null;
    }
  }
}
