import 'package:congrega/features/authentication/AuthenticationBloc.dart';
import 'package:congrega/features/lifecounter/data/game/GamePersistance.dart';
import 'package:congrega/features/lifecounter/data/game/GameRepository.dart';
import 'package:congrega/features/lifecounter/data/PlayerRepository.dart';
import 'package:congrega/features/lifecounter/presentation/bloc/LifeCounterBloc.dart';
import 'package:congrega/features/loginSignup/presentation/bloc/LoginBloc.dart';
import 'package:congrega/features/loginSignup/presentation/bloc/signup/SignUpBloc.dart';
import 'package:congrega/features/lifecounter/data/match/MatchPersistance.dart';
import 'package:congrega/features/lifecounter/data/match/MatchRepository.dart';
import 'package:congrega/features/tournaments/data/TournamentController.dart';
import 'package:congrega/features/tournaments/data/datasources/TournamentHttpClient.dart';
import 'package:congrega/features/tournaments/data/repositories/TournamentRepository.dart';
import 'package:congrega/features/users/UserHttpClient.dart';
import 'package:congrega/features/users/UserRepository.dart';
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

  void configure(){
    _configureCommonUtilitiesFactories();
    _configureSignInModuleFactories();
    _configureLoginModuleFactories();
    _configureTournamentsModuleFactories();
    _configureAuthenticationBlocModuleFactories();
    _configureUserModuleFactories();
    _configureGameBlocModuleFactories();
    _configureMatchBlocModuleFactories();
  }

  @Register.factory(MatchPersistence)
  @Register.factory(MatchRepository)
  @Register.factory(MatchController)
  @Register.factory(MatchBloc)
  void _configureMatchBlocModuleFactories();

  @Register.factory(GamePersistence)
  @Register.singleton(PlayerRepository)
  @Register.singleton(GameRepository)
  @Register.factory(LifeCounterBloc)
  void _configureGameBlocModuleFactories();

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

}

class DepInj {
  static void setup() {
    var injector = _$Injector();
    injector.configure();
  }
}