import 'package:congrega/model/User.dart';
import 'package:equatable/equatable.dart';

enum TournamentStatus { scheduled, waiting, inProgress, ended}

class Tournament extends Equatable {

  const Tournament({
    this.name,
    this.type,
    this.playerList,
    this.adminList,
    this.judgeList,
    this.startingTime,
    this.status,
    this.round,
  });

  final String name;
  final String type;
  final Set<User> playerList;
  final Set<User> adminList;
  final Set<User> judgeList;
  final DateTime startingTime;
  final TournamentStatus status;
  final int round;

  TournamentStatus getStatus(){
    if(this.status == TournamentStatus.ended)
      return TournamentStatus.ended;

    DateTime now = DateTime.now();
    if (now.isAfter(startingTime))
      return TournamentStatus.inProgress;

    return TournamentStatus.scheduled;
  }

  bool isUserEnrolled(User user) => playerList.contains(user);

  Tournament copyWith({String name, String type, Set<User> playerList,
    Set<User> adminList, Set<User> judgeList, DateTime startingTime,
    TournamentStatus status, int round}){
    return Tournament(
      name: name ?? this.name,
      type: type ?? this.type,
      playerList: playerList ?? this.playerList,
      adminList: adminList ?? this.adminList,
      judgeList: judgeList ?? this.judgeList,
      startingTime: startingTime ?? this.startingTime,
      status: status ?? this.status,
      round: round ?? this.round
    );
  }

  @override
  List<Object> get props => [name, type, status];

}