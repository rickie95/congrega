// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injector.dart';

// **************************************************************************
// KiwiInjectorGenerator
// **************************************************************************

class _$Injector extends Injector {
  @override
  void _configureTournamentsModuleFactories() {
    final KiwiContainer container = KiwiContainer();
    container.registerFactory((c) => Client());
    container.registerFactory((c) => TournamentHttpClient(c<Client>()));
  }

  @override
  void _configureAuthenticationModuleFactories() {
    final KiwiContainer container = KiwiContainer();
    container.registerFactory((c) => AuthenticationRepository());
    container.registerFactory((c) => UserRepository());
    container.registerFactory((c) => AuthenticationBloc(
        authenticationRepository: c<AuthenticationRepository>(),
        userRepository: c<UserRepository>()));
  }

  @override
  void _configureSignUpModuleFactories() {
    final KiwiContainer container = KiwiContainer();
    container.registerFactory((c) => SignUpService());
    container
        .registerFactory((c) => SignUpBloc(signUpService: c<SignUpService>()));
  }
}
