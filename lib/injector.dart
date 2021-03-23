import 'package:congrega/authentication/AuthenticationBloc.dart';
import 'package:congrega/features/loginSignup/presentation/bloc/LoginBloc.dart';
import 'package:congrega/features/loginSignup/presentation/bloc/signup/SignUpBloc.dart';
import 'package:congrega/features/tournaments/data/datasources/TournamentHttpClient.dart';
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
    _configureTournamentsModuleFactories();
    _configureAuthenticationBlocModuleFactories();
    _configureSignUpModuleFactories();
  }

  @Register.factory(http.Client)
  @Register.factory(TournamentHttpClient)
  void _configureTournamentsModuleFactories();

  @Register.factory(FlutterSecureStorage)
  @Register.singleton(AuthenticationHttpClient)
  @Register.singleton(AuthenticationRepository)
  @Register.factory(UserRepository)
  @Register.singleton(AuthenticationBloc)
  @Register.factory(LoginBloc)
  void _configureAuthenticationBlocModuleFactories();


  @Register.factory(SignUpService)
  @Register.factory(SignUpBloc)
  void _configureSignUpModuleFactories();

}

class DepInj {
  static void setup() {
    var injector = _$Injector();
    injector.configure();
  }
}