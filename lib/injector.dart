import 'package:congrega/authentication/AuthenticationBloc.dart';
import 'package:congrega/features/loginSignup/presentation/bloc/signup/SignUpBloc.dart';
import 'package:congrega/features/tournaments/data/datasources/TournamentHttpClient.dart';
import 'package:congrega/user/UserRepository.dart';
import 'package:http/http.dart';
import 'package:kiwi/kiwi.dart';
import 'package:http/http.dart' as http;

import 'authentication/AuthenticationRepository.dart';

part 'injector.g.dart';

abstract class Injector {

  void configure(){
    _configureTournamentsModuleFactories();
    _configureAuthenticationModuleFactories();
    _configureSignUpModuleFactories();
  }

  @Register.factory(http.Client)
  @Register.factory(TournamentHttpClient)
  void _configureTournamentsModuleFactories();
  
  
  @Register.factory(AuthenticationRepository)
  @Register.factory(UserRepository)
  @Register.factory(AuthenticationBloc)
  void _configureAuthenticationModuleFactories();


  @Register.factory(SignUpService)
  @Register.factory(SignUpBloc)
  void _configureSignUpModuleFactories();

}