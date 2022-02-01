import 'package:congrega/features/authentication/AuthenticationBloc.dart';
import 'package:congrega/features/dashboard/presentation/widgets/friends_widget/bloc/friends_widget_bloc.dart';
import 'package:congrega/features/friends/data/friends_repository.dart';
import 'package:congrega/features/lifecounter/data/game/GamePersistance.dart';
import 'package:congrega/features/lifecounter/data/game/GameRepository.dart';
import 'package:congrega/features/lifecounter/data/PlayerRepository.dart';
import 'package:congrega/features/lifecounter/data/game/game_client.dart';
import 'package:congrega/features/lifecounter/data/game/game_live_manager.dart';
import 'package:congrega/features/lifecounter/data/match/MatchClient.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/LifeCounterBloc.dart';
import 'package:congrega/features/loginSignup/presentation/bloc/LoginBloc.dart';
import 'package:congrega/features/loginSignup/presentation/bloc/signup/SignUpBloc.dart';
import 'package:congrega/features/lifecounter/data/match/MatchPersistance.dart';
import 'package:congrega/features/lifecounter/data/match/MatchRepository.dart';
import 'package:congrega/features/profile_page/bloc/current_deck_stats_bloc/current_deck_stats_bloc.dart';
import 'package:congrega/features/profile_page/data/stats_persistence.dart';
import 'package:congrega/features/profile_page/data/stats_repo.dart';
import 'package:congrega/features/tournaments/data/TournamentController.dart';
import 'package:congrega/features/tournaments/data/datasources/TournamentHttpClient.dart';
import 'package:congrega/features/tournaments/data/repositories/TournamentRepository.dart';
import 'package:congrega/features/tournaments/presentation/event_form_bloc/event_form_bloc.dart';
import 'package:congrega/features/users/UserHttpClient.dart';
import 'package:congrega/features/users/UserRepository.dart';
import 'package:congrega/features/websocket/invitation_manager.dart';
import 'package:congrega/utils/Arcano.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:kiwi/kiwi.dart';

import 'features/authentication/AuthenticationRepository.dart';
import 'features/loginSignup/data/AuthenticationHttpClient.dart';
import 'features/lifecounter/presentation/bloc/match/MatchBloc.dart';
import 'features/lifecounter/data/match/MatchController.dart';
import 'features/tournaments/presentation/bloc/TournamentBloc.dart';

part 'injector.g.dart';

abstract class Injector {
  void configure() {
    _configureCommonUtilitiesFactories();
    _configureEventFormBloc();
    _configureSignInModuleFactories();
    _configureLoginModuleFactories();
    _configureTournamentsModuleFactories();
    _configureAuthenticationBlocModuleFactories();
    _configureUserModuleFactories();
    _configureGameBlocModuleFactories();
    _configureMatchBlocModuleFactories();
    _configureGraphQLClient();
    _configureFriendsModule();
    _configureWebSocketServices();
    _configureGameFactories();
    _configureStatsRepo();
  }

  @Register.factory(EventFormBloc)
  void _configureEventFormBloc();

  @Register.singleton(ArcanoGraphQLClient)
  void _configureGraphQLClient();

  @Register.factory(MatchClient)
  @Register.factory(MatchPersistence)
  @Register.factory(MatchRepository)
  @Register.factory(MatchController)
  @Register.singleton(MatchBloc)
  void _configureMatchBlocModuleFactories();

  @Register.singleton(PlayerRepository)
  @Register.factory(LifeCounterBloc)
  void _configureGameBlocModuleFactories();

  @Register.singleton(GameLiveManager)
  @Register.factory(GameClient)
  @Register.factory(GamePersistence)
  @Register.singleton(GameRepository)
  void _configureGameFactories();

  @Register.singleton(FlutterSecureStorage)
  @Register.factory(http.Client)
  void _configureCommonUtilitiesFactories();

  @Register.factory(UserHttpClient)
  @Register.factory(UserRepository)
  void _configureUserModuleFactories();

  @Register.factory(TournamentHttpClient)
  @Register.singleton(TournamentRepository)
  @Register.factory(TournamentController)
  @Register.singleton(TournamentBloc)
  void _configureTournamentsModuleFactories();

  @Register.singleton(AuthenticationHttpClient)
  @Register.singleton(AuthenticationRepository)
  @Register.singleton(AuthenticationBloc)
  void _configureAuthenticationBlocModuleFactories();

  @Register.factory(SignUpBloc)
  void _configureSignInModuleFactories();

  @Register.factory(LoginBloc)
  void _configureLoginModuleFactories();

  @Register.singleton(FriendsWidgetBloc)
  @Register.factory(FriendRepository)
  void _configureFriendsModule();

  @Register.singleton(InvitationManager)
  void _configureWebSocketServices();

  @Register.singleton(StatsPersistence)
  @Register.singleton(StatsRepo)
  @Register.singleton(CurrentDeckStatsBloc)
  void _configureStatsRepo();
}

class DepInj {
  static void setup() {
    var injector = _$Injector();
    injector.configure();
  }
}
