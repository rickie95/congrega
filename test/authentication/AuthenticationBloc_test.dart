import 'package:congrega/features/authentication/AuthenticationBloc.dart';
import 'package:congrega/features/authentication/AuthenticationEvent.dart';
import 'package:congrega/features/authentication/AuthenticationRepository.dart';
import 'package:congrega/features/authentication/AuthenticationState.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/features/users/UserRepository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';


class MockUserRepository extends Mock implements UserRepository {}
class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}

void main() {
  const User user = User(username: 'mike', id: '2');
  late AuthenticationRepository authenticationRepository;
  late UserRepository userRepository;

  setUp(() {
    authenticationRepository = MockAuthenticationRepository();
    when(() => authenticationRepository.status)
        .thenAnswer((_) => const Stream<AuthenticationStatus>.empty());
    userRepository = MockUserRepository();
  });

  group('AuthenticationBloc', () {
    test('initial state is AuthenticationState.unknown', () {
      final authenticationBloc = AuthenticationBloc(
        authenticationRepository: authenticationRepository,
        userRepository: userRepository,
      );
      expect(authenticationBloc.state, const AuthenticationState.unknown());
      authenticationBloc.close();
    });

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [unauthenticated] when status is unauthenticated',
      build: () {
        when(() => authenticationRepository.status).thenAnswer(
              (_) => Stream.value(AuthenticationStatus.unauthenticated)
        );
        return AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository,
        );
      },
      expect: () => const <AuthenticationState>[
        AuthenticationState.unauthenticated(),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [authenticated] when status is authenticated',
      build: () {
        when(() => authenticationRepository.status).thenAnswer(
              (_) => Stream.value(AuthenticationStatus.authenticated),
        );
        when(() => userRepository.getUser()).thenAnswer((_) async => user);
        return AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository,
        );
      },
      expect: () => const <AuthenticationState>[
        AuthenticationState.authenticated(user),
      ],
    );
  });

  group('AuthenticationStatusChanged', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [authenticated] when status is authenticated',
      build: () {
        when(() => authenticationRepository.status).thenAnswer(
              (_) => Stream.value(AuthenticationStatus.authenticated),
        );
        when(() => userRepository.getUser()).thenAnswer((_) async => user);
        return AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository,
        );
      },
      act: (bloc) => bloc.add(
        const AuthenticationStatusChanged(AuthenticationStatus.authenticated),
      ),
      expect: () => const <AuthenticationState>[
        AuthenticationState.authenticated(user),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [unauthenticated] when status is unauthenticated',
      build: () {
        when(() => authenticationRepository.status).thenAnswer(
              (_) => Stream.value(AuthenticationStatus.unauthenticated),
        );
        return AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository,
        );
      },
      act: (bloc) => bloc.add(
        const AuthenticationStatusChanged(AuthenticationStatus.unauthenticated),
      ),
      expect: () => const <AuthenticationState>[
        AuthenticationState.unauthenticated(),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [unauthenticated] when status is authenticated but getUser fails',
      build: () {
        when(() => userRepository.getUser()).thenThrow(Exception('oops'));
        return AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository,
        );
      },
      act: (bloc) => bloc.add(
        const AuthenticationStatusChanged(AuthenticationStatus.authenticated),
      ),
      expect: () => const <AuthenticationState>[
        AuthenticationState.unauthenticated(),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [unauthenticated] when status is authenticated '
          'but getUser returns null',
      build: () {
        when(() => userRepository.getUser()).thenAnswer((_) async => throw Exception());
        return AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository,
        );
      },
      act: (bloc) => bloc.add(
        const AuthenticationStatusChanged(AuthenticationStatus.authenticated),
      ),
      expect: () =>
      const <AuthenticationState>[AuthenticationState.unauthenticated()],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [unknown] when status is unknown',
      build: () {
        when(() => authenticationRepository.status).thenAnswer(
              (_) => Stream.value(AuthenticationStatus.unknown),
        );
        return AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository,
        );
      },
      act: (bloc) => bloc.add(
        const AuthenticationStatusChanged(AuthenticationStatus.unknown),
      ),
      expect: () => const <AuthenticationState>[
        AuthenticationState.unknown(),
      ],
    );
  });

  group('AuthenticationLogoutRequested', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'calls logOut on authenticationRepository '
          'when AuthenticationLogoutRequested is added',
      build: () {
        return AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository,
        );
      },
      act: (bloc) => bloc.add(AuthenticationLogoutRequested()),
      verify: (_) {
        verify(() => authenticationRepository.logOut()).called(1);
      },
    );
  });
}
