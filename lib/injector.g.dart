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
  void _configureAuthenticationBlocModuleFactories() {
    final KiwiContainer container = KiwiContainer();
    container.registerFactory((c) => FlutterSecureStorage());
    container.registerSingleton((c) => AuthenticationHttpClient(c<Client>()));
    container.registerSingleton((c) => AuthenticationRepository(
        storage: c<FlutterSecureStorage>(),
        authClient: c<AuthenticationHttpClient>()));
    container.registerFactory((c) => UserRepository());
    container.registerSingleton((c) => AuthenticationBloc(
        authenticationRepository: c<AuthenticationRepository>(),
        userRepository: c<UserRepository>()));
    container.registerFactory((c) =>
        LoginBloc(authenticationRepository: c<AuthenticationRepository>()));
  }

  @override
  void _configureSignUpModuleFactories() {
    final KiwiContainer container = KiwiContainer();
    container.registerFactory((c) =>
        SignUpBloc(authenticationRepository: c<AuthenticationRepository>()));
  }
}
