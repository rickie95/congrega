import 'package:congrega/features/lifecounter/model/Player.dart';
import 'package:congrega/features/lifecounter/model/PlayerPoints.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/features/users/UserRepository.dart';

class PlayerRepository {
  
  PlayerRepository({required this.userRepository});
  
  final UserRepository userRepository;
  
  Player fromUser(User user){
    return Player(
      user: user,
      points: {new LifePoints(20)}
    );
  }

  Future<Player> getAuthenticatedPlayer() async {
    User user = await userRepository.getUser();
    return fromUser(user);
  }

  Player genericOpponent(){
    return fromUser(User(
      id: 'generic-opponent',
      name: 'Opponent',
      username: 'generic-opponent'
    ));
  }
}