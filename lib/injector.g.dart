// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injector.dart';

// **************************************************************************
// KiwiInjectorGenerator
// **************************************************************************

class _$Injector extends Injector {
  @override
  void _configureMatchBlocModuleFactories() {
    final KiwiContainer container = KiwiContainer();
    container.registerFactory((c) => MatchPersistence());
    container.registerFactory(
        (c) => MatchRepository(persistence: c<MatchPersistence>()));
    container.registerFactory((c) => MatchController(
        matchRepository: c<MatchRepository>(),
        playerRepository: c<PlayerRepository>()));
    container.registerFactory((c) => MatchBloc(
        matchController: c<MatchController>(),
        gameRepository: c<GameRepository>()));
  }

  @override
  void _configureGameBlocModuleFactories() {
    final KiwiContainer container = KiwiContainer();
    container.registerFactory((c) => GamePersistence());
    container.registerSingleton(
        (c) => PlayerRepository(userRepository: c<UserRepository>()));
    container.registerSingleton((c) => GameRepository(
        playerRepository: c<PlayerRepository>(),
        persistence: c<GamePersistence>()));
    container.registerFactory(
        (c) => LifeCounterBloc(gameRepository: c<GameRepository>()));
  }

  @override
  void _configureCommonUtilitiesFactories() {
    final KiwiContainer container = KiwiContainer();
    container.registerSingleton((c) => FlutterSecureStorage());
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
        authClient: c<AuthenticationHttpClient>(),
        userRepository: c<UserRepository>()));
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
