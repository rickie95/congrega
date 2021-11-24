import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/features/users/UserHttpClient.dart';
import 'package:congrega/features/users/UserRepository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'UserRepository_test.mocks.dart';


@GenerateMocks([UserHttpClient, FlutterSecureStorage])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Save and recover user', () async {
    User user = new User(
      id: 'user-001',
      username: 'pippo',
      password: 'secret',
      name: 'Pippo'
    );

    FlutterSecureStorage mockedStorage = new MockFlutterSecureStorage();
    when(mockedStorage.write(key: UserRepository.USERNAME_KEY, value: user.username)).thenAnswer((_) => Future.value());
    when(mockedStorage.write(key: UserRepository.PASSWORD_KEY, value: user.password)).thenAnswer((_) => Future.value());
    when(mockedStorage.write(key: UserRepository.ID_KEY, value: user.id)).thenAnswer((_) => Future.value());
    when(mockedStorage.write(key: UserRepository.NAME_KEY, value: user.name)).thenAnswer((_) => Future.value());

    UserRepository userRepo = new UserRepository(
        userHttpClient: new MockUserHttpClient(),
        secureStorage: mockedStorage);
    
    userRepo.saveUserAccountInfo(user);

    verify(mockedStorage.write(key: UserRepository.USERNAME_KEY, value: user.username));
    verify(mockedStorage.write(key: UserRepository.PASSWORD_KEY, value: user.password));
    verify(mockedStorage.write(key: UserRepository.ID_KEY, value: user.id));
    verify(mockedStorage.write(key: UserRepository.NAME_KEY, value: user.name));
  });
  
}