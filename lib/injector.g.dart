// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injector.dart';

// **************************************************************************
// KiwiInjectorGenerator
// **************************************************************************

class _$Injector extends Injector {
  @override
  void _configureGameBlocModuleFactories() {
    final KiwiContainer container = KiwiContainer();
    container.registerSingleton(
        (c) => PlayerRepository(userRepository: c<UserRepository>()));
    container.registerSingleton(
        (c) => GameRepository(playerRepository: c<PlayerRepository>()));
    container
        .registerFactory((c) => GameBloc(gameRepository: c<GameRepository>()));
  }

  @override
  void _configureCommonUtilitiesFactories() {
    final KiwiContainer container = KiwiContainer();
    container.registerFactory((c) => FlutterSecureStorage());
    container.registerFactory((c) => Client());
  }

  @override
  void _configureUserModuleFactories() {
    final KiwiContainer container = KiwiContainer();
    container.registerFactory((c) => UserHttpClient(c<Client>()));
    container.registerFactory((c) => UserRepository(
        userHttpClient: c<UserHttpClient>(),
        secureStorage: c<FlutterSecureStorage>()));
  }

  @override
  void _configureTournamentsModuleFactories() {
    final KiwiContainer container = KiwiContainer();
    container.registerFactory((c) => TournamentHttpClient(c<Client>()));
    container.registerSingleton((c) => TournamentRepository());
    container.registerFactory(
        (c) => TournamentController(repository: c<TournamentRepository>()));
  }

  @override
  void _configureAuthenticationBlocModuleFactories() {
    final KiwiContainer container = KiwiContainer();
    container.registerSingleton((c) => AuthenticationHttpClient(c<Client>()));
    container.registerSingleton((c) => AuthenticationRepository(
        storage: c<FlutterSecureStorage>(),
        authClient: c<AuthenticationHttpClient>()));
    container.registerSingleton((c) => AuthenticationBloc(
        authenticationRepository: c<AuthenticationRepository>(),
        userRepository: c<UserRepository>()));
  }

  @override
  void _configureSignInModuleFactories() {
    final KiwiContainer container = KiwiContainer();
    container.registerFactory((c) =>
        SignUpBloc(authenticationRepository: c<AuthenticationRepository>()));
  }

  @override
  void _configureLoginModuleFactories() {
    final KiwiContainer container = KiwiContainer();
    container.registerFactory((c) =>
        LoginBloc(authenticationRepository: c<AuthenticationRepository>()));
  }
}
