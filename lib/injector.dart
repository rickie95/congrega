import 'package:congrega/authentication/AuthenticationBloc.dart';
import 'package:congrega/features/loginSignup/presentation/bloc/LoginBloc.dart';
import 'package:congrega/features/loginSignup/presentation/bloc/signup/SignUpBloc.dart';
import 'package:congrega/features/tournaments/data/datasources/TournamentHttpClient.dart';
import 'package:congrega/httpClients/UserHttpClient.dart';
import 'package:congrega/user/UserRepository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:kiwi/kiwi.dart';

import 'authentication/AuthenticationRepository.dart';
import 'features/loginSignup/data/AuthenticationHttpClient.dart';

part 'injector.g.dart';

abstract class Injector {

  void configure(){
    _configureCommonUtilitiesFactories();
    _configureSignInModuleFactories();
    _configureLoginModuleFactories();
    _configureTournamentsModuleFactories();
    _configureAuthenticationBlocModuleFactories();
    _configureUserModuleFactories();
  }

  @Register.factory(FlutterSecureStorage)
  @Register.factory(http.Client)
  void _configureCommonUtilitiesFactories();

  @Register.factory(UserHttpClient)
  @Register.factory(UserRepository)
  void _configureUserModuleFactories();

  @Register.factory(TournamentHttpClient)
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