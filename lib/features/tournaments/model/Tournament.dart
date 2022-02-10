import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:equatable/equatable.dart';

enum TournamentStatus { SCHEDULED, WAITING, IN_PROGRESS, ENDED, UNKNOWN }

extension TournamentStatusValueToString on TournamentStatus {
  String valueToString() {
    return this.toString().split('.').last;
  }
}

class Tournament extends Equatable {
  const Tournament(
      {required this.id,
      required this.name,
      required this.playerList,
      required this.adminList,
      required this.judgeList,
      required this.type,
      required this.startingTime,
      required this.status,
      required this.round,
      this.location});

  final String id;
  final String name;
  final String type;
  final Set<User> playerList;
  final Set<User> adminList;
  final Set<User> judgeList;
  final DateTime? startingTime;
  final TournamentStatus status;
  final int round;
  final String? location;

  TournamentStatus getStatus() {
    if (this.status == TournamentStatus.ENDED) return TournamentStatus.ENDED;

    DateTime now = DateTime.now();
    if (now.isAfter(startingTime!)) return TournamentStatus.IN_PROGRESS;

    return TournamentStatus.SCHEDULED;
  }

  bool isUserEnrolled(User user) => playerList.contains(user);
  bool isUserAdmin(User user) => adminList.contains(user);

  Tournament copyWith(
      {String? id,
      String? name,
      String? type,
      Set<User>? playerList,
      Set<User>? adminList,
      Set<User>? judgeList,
      DateTime? startingTime,
      TournamentStatus? status,
      int? round,
      Uri? eventUri}) {
    return Tournament(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      playerList: playerList ?? this.playerList,
      adminList: adminList ?? this.adminList,
      judgeList: judgeList ?? this.judgeList,
      startingTime: startingTime ?? this.startingTime,
      status: status ?? this.status,
      round: round ?? this.round,
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

  static Set<User> decodeUserList(List<Object?> userList) {
    return userList.map((dynamic obj) => new User.fromObject(obj)).toSet();
  }

  static TournamentStatus parseTournamentStatus(String statusAsString) {
    if (TournamentStatus.IN_PROGRESS.toString().contains(statusAsString))
      return TournamentStatus.IN_PROGRESS;

    if (TournamentStatus.SCHEDULED.toString().contains(statusAsString))
      return TournamentStatus.SCHEDULED;

    if (TournamentStatus.ENDED.toString().contains(statusAsString)) return TournamentStatus.ENDED;

    if (TournamentStatus.WAITING.toString().contains(statusAsString))
      return TournamentStatus.WAITING;

    if (TournamentStatus.UNKNOWN.toString().contains(statusAsString))
      return TournamentStatus.UNKNOWN;

    throw Exception(
        "DeserializationError: couldn't deserialize properly status => '$statusAsString'");
  }

  Map<String, dynamic> toJson() => {
        "id": this.id,
        "name": this.name,
        "type": this.type,
        "playerList": UserBrief.fromUserList(this.playerList.toList()),
        "adminList": UserBrief.fromUserList(this.adminList.toList()),
        "judgeList": UserBrief.fromUserList(this.judgeList.toList()),
        "startingTime": this.startingTime!.toIso8601String(),
        "status": this.status.valueToString(),
        "round": this.round
      };

  Map<String, dynamic> toBriefJson() {
    Map<String, dynamic> map = this.toJson();
    map.remove('id');
    return map;
  }

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
    status: TournamentStatus.UNKNOWN,
    round: 0,
  );
}
