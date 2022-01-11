// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injector.dart';

// **************************************************************************
// KiwiInjectorGenerator
// **************************************************************************

class _$Injector extends Injector {
  @override
  void _configureEventFormBloc() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerFactory((c) => EventFormBloc(
          tournamentController: c<TournamentController>(),
          userRepository: c<UserRepository>()));
  }

  @override
  void _configureGraphQLClient() {
    final KiwiContainer container = KiwiContainer();
    container..registerSingleton((c) => ArcanoGraphQLClient());
  }

  @override
  void _configureMatchBlocModuleFactories() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerFactory((c) => MatchClient(httpClient: c<Client>()))
      ..registerFactory((c) => MatchPersistence())
      ..registerFactory((c) => MatchRepository(
          persistence: c<MatchPersistence>(), matchClient: c<MatchClient>()))
      ..registerFactory((c) => MatchController(
          matchRepository: c<MatchRepository>(),
          playerRepository: c<PlayerRepository>(),
          userRepository: c<UserRepository>(),
          gameRepository: c<GameRepository>()))
      ..registerSingleton(
          (c) => MatchBloc(matchController: c<MatchController>()));
  }

  @override
  void _configureGameBlocModuleFactories() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerSingleton(
          (c) => PlayerRepository(userRepository: c<UserRepository>()))
      ..registerFactory((c) => LifeCounterBloc(
          gameRepository: c<GameRepository>(),
          gameLiveManager: c<GameLiveManager>()));
  }

  @override
  void _configureGameFactories() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerSingleton((c) => GameLiveManager())
      ..registerFactory((c) => GameClient(
          httpClient: c<Client>(), authRepo: c<AuthenticationRepository>()))
      ..registerFactory((c) => GamePersistence())
      ..registerSingleton((c) => GameRepository(
          playerRepository: c<PlayerRepository>(),
          persistence: c<GamePersistence>(),
          gameClient: c<GameClient>()));
  }

  @override
  void _configureCommonUtilitiesFactories() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerSingleton((c) => FlutterSecureStorage())
      ..registerFactory((c) => Client());
  }

  @override
  void _configureUserModuleFactories() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerFactory((c) => UserHttpClient(c<Client>()))
      ..registerFactory((c) => UserRepository(
          userHttpClient: c<UserHttpClient>(),
          secureStorage: c<FlutterSecureStorage>()));
  }

  @override
  void _configureTournamentsModuleFactories() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerFactory((c) => TournamentHttpClient(
          graphQLClient: c<ArcanoGraphQLClient>(), restClient: c<Client>()))
      ..registerSingleton((c) =>
          TournamentRepository(tournamentHttpClient: c<TournamentHttpClient>()))
      ..registerFactory(
          (c) => TournamentController(repository: c<TournamentRepository>()))
      ..registerSingleton(
          (c) => TournamentBloc(controller: c<TournamentController>()));
  }

  @override
  void _configureAuthenticationBlocModuleFactories() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerSingleton((c) => AuthenticationHttpClient(c<Client>()))
      ..registerSingleton((c) => AuthenticationRepository(
          storage: c<FlutterSecureStorage>(),
          authClient: c<AuthenticationHttpClient>(),
          userRepository: c<UserRepository>()))
      ..registerSingleton((c) => AuthenticationBloc(
          authenticationRepository: c<AuthenticationRepository>(),
          userRepository: c<UserRepository>()));
  }

  @override
  void _configureSignInModuleFactories() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerFactory((c) =>
          SignUpBloc(authenticationRepository: c<AuthenticationRepository>()));
  }

  @override
  void _configureLoginModuleFactories() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerFactory((c) =>
          LoginBloc(authenticationRepository: c<AuthenticationRepository>()));
  }

  @override
  void _configureFriendsModule() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerSingleton((c) => FriendsWidgetBloc())
      ..registerFactory(
          (c) => FriendRepository(secureStorage: c<FlutterSecureStorage>()));
  }

  @override
  void _configureWebSocketServices() {
    final KiwiContainer container = KiwiContainer();
    container..registerSingleton((c) => InvitationManager());
  }
}
