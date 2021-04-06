class Arcano {

  static const String SCHEME = 'http';
  static const String IP_ADDRESS = "192.168.1.59";
  static const int PORT = 8080;

  static const String BASE_URL = "https://$IP_ADDRESS:$PORT/arcano";

  static const String ARCANO = '/arcano';

  static const String USERS_URL ="$ARCANO/users";
  static const String MATCHES_URL = "$ARCANO/matches";
  static const String EVENTS_URL = "$ARCANO/events";
  static const String AUTH_URL = "$ARCANO/auth";
  static const String USERS_URL_BY_USERNAME = USERS_URL + '/byUsername';

  static Uri getAuthUri(){
    return Uri(
        scheme: SCHEME,
        host: Arcano.IP_ADDRESS,
        path: Arcano.AUTH_URL,
        port: Arcano.PORT
    );
  }

  static Uri getUsersUri(){
    return Uri(
        scheme: SCHEME,
        host: Arcano.IP_ADDRESS,
        path: Arcano.USERS_URL,
        port: Arcano.PORT
    );
  }

  static Uri getUserByUsernameUri(String username){
    return Uri(
        scheme: SCHEME,
        host: Arcano.IP_ADDRESS,
        path: Arcano.USERS_URL_BY_USERNAME + '/$username',
        port: Arcano.PORT
    );
  }
}