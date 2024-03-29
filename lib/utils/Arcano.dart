import 'dart:io';

import 'package:graphql_flutter/graphql_flutter.dart' as graphQL;

class Arcano {
  static const String SCHEME = 'http';
  static const String WS_SCHEME = 'ws';
  static const String IP_ADDRESS = "192.168.1.63";
  static const int PORT = 8080;

  static const String BASE_URL = "http://$IP_ADDRESS:$PORT/arcano";

  static const String ARCANO = '/arcano';

  static const String USERS_URL = "$ARCANO/users";
  static const String GAMES_URL = "$ARCANO/games/";
  static const String MATCHES_URL = "$ARCANO/matches";
  static const String EVENTS_URL = "$ARCANO/events";
  static const String AUTH_URL = "$ARCANO/auth";
  static const String USERS_URL_BY_USERNAME = USERS_URL + '/byUsername';
  static const String WS_PATH = "$ARCANO" + '/ws-arcano/';

  static const String GRAPH_QL_ENDPOINT = "$ARCANO/graphql";

  static Link getGraphQlLink() {
    return Link(getGraphQlUri().toString());
  }

  static Uri enrollUserInEventUri(String eventUIID, String userUIID) {
    return Uri(
        scheme: SCHEME,
        host: Arcano.IP_ADDRESS,
        path: Arcano.EVENTS_URL + "/$eventUIID/player/$userUIID",
        port: Arcano.PORT);
  }

  static Uri getGraphQlUri() {
    return Uri(
        scheme: SCHEME, host: Arcano.IP_ADDRESS, path: Arcano.GRAPH_QL_ENDPOINT, port: Arcano.PORT);
  }

  static Uri getEventsUri() {
    return Uri(scheme: SCHEME, host: Arcano.IP_ADDRESS, path: Arcano.EVENTS_URL, port: Arcano.PORT);
  }

  static Uri getAuthUri() {
    return Uri(scheme: SCHEME, host: Arcano.IP_ADDRESS, path: Arcano.AUTH_URL, port: Arcano.PORT);
  }

  static Uri getUsersUri() {
    return Uri(scheme: SCHEME, host: Arcano.IP_ADDRESS, path: Arcano.USERS_URL, port: Arcano.PORT);
  }

  static Uri getUserByUsernameUri(String username) {
    return Uri(
        scheme: SCHEME,
        host: Arcano.IP_ADDRESS,
        path: Arcano.USERS_URL_BY_USERNAME + '/$username',
        port: Arcano.PORT);
  }

  static Uri getWSPlayerUri(String playerId) {
    return Uri(
        scheme: WS_SCHEME,
        host: Arcano.IP_ADDRESS,
        path: Arcano.WS_PATH + '$playerId',
        port: Arcano.PORT);
  }

  static Uri getWSGameUri(String gameId, String playerId) {
    return Uri(
        scheme: WS_SCHEME,
        host: Arcano.IP_ADDRESS,
        path: Arcano.WS_PATH + '$gameId/' + '$playerId',
        port: Arcano.PORT);
  }

  static Uri getMatchUri({String? matchId}) {
    return Uri(
        scheme: SCHEME,
        host: Arcano.IP_ADDRESS,
        path: Arcano.MATCHES_URL + "/" + (matchId ?? ""),
        port: Arcano.PORT);
  }

  static Uri getGamesUri({String? gameId}) => Uri(
      scheme: SCHEME,
      host: Arcano.IP_ADDRESS,
      path: Arcano.GAMES_URL + (gameId ?? ""),
      port: Arcano.PORT);
}

class ArcanoGraphQLLink extends graphQL.HttpLink {
  ArcanoGraphQLLink() : super(Arcano.getGraphQlUri().toString());
}

class ArcanoGraphQLClient extends graphQL.GraphQLClient {
  ArcanoGraphQLClient()
      : super(
            link: ArcanoGraphQLLink(), cache: graphQL.GraphQLCache(store: graphQL.InMemoryStore()));
}
