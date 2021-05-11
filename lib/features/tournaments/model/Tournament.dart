import 'dart:convert';

import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:equatable/equatable.dart';

enum TournamentStatus { scheduled, waiting, inProgress, ended, unknown}

class Tournament extends Equatable {

  const Tournament({
    required this.id,
    required this.name,
    required this.playerList,
    required this.adminList,
    required this.judgeList,
    required this.type,
    required this.startingTime,
    required this.status,
    required this.round,
  });

  final String id;
  final String name;
  final String type;
  final Set<User> playerList;
  final Set<User> adminList;
  final Set<User> judgeList;
  final DateTime? startingTime;
  final TournamentStatus status;
  final int round;

  TournamentStatus getStatus(){
    if(this.status == TournamentStatus.ended)
      return TournamentStatus.ended;

    DateTime now = DateTime.now();
    if (now.isAfter(startingTime!))
      return TournamentStatus.inProgress;

    return TournamentStatus.scheduled;
  }

  bool isUserEnrolled(User user) => playerList.contains(user);

  Tournament copyWith({String? id, String? name, String? type, Set<User>? playerList,
    Set<User>? adminList, Set<User>? judgeList, DateTime? startingTime,
    TournamentStatus? status, int? round}){
    return Tournament(
        id: id ?? this.id,
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

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      playerList: decodeUserList(json['playerList']),
      adminList: decodeUserList(json['adminList']),
      judgeList: decodeUserList(json['judgeList']),
      startingTime: DateTime.parse(json['startingTime']),
      status: parseTournamentStatus(json['status']),
      round: json['round'],
    );
  }

  static Set<User> decodeUserList(String sourceList) {
    Iterable lis = jsonDecode(sourceList);
    return Set<User>.from(lis.map((listElement) => User.fromJson(listElement)));
  }

  static TournamentStatus parseTournamentStatus(String statusAsString){
   if(statusAsString == TournamentStatus.inProgress.toString())
     return TournamentStatus.inProgress;

   if(statusAsString == TournamentStatus.scheduled.toString())
     return TournamentStatus.scheduled;

   if(statusAsString == TournamentStatus.ended.toString())
     return TournamentStatus.ended;

   if(statusAsString == TournamentStatus.waiting.toString())
     return TournamentStatus.waiting;

   if(statusAsString == TournamentStatus.unknown.toString())
     return TournamentStatus.unknown;

   throw Exception("DeserializationError: couldn't deserialize properly status => '$statusAsString'");
  }

  Map<String, dynamic> toJson() => {
    "id": this.id,
    "name": this.name,
    "type": this.type,
    "playerList": jsonEncode(this.playerList.toList()),
    "adminList" : jsonEncode(this.adminList.toList()),
    "judgeList" : jsonEncode(this.judgeList.toList()),
    "startingTime" : this.startingTime!.toIso8601String(),
    "status": this.status.toString(),
    "round": this.round
  };


  @override
  List<Object> get props => [id];

  static const empty = Tournament(
      id: "-",
      name: "",
      playerList: {},
      adminList: {},
      judgeList: {},
      type: "",
      startingTime: null,
      status: TournamentStatus.unknown,
      round: 0
  );

}