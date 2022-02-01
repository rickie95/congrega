import 'deck.dart';

class StatsRecord {
  DateTime date;
  int userScore;
  int opponentScore;
  String opponentUsername;
  Deck deck;

  StatsRecord(this.date, this.userScore, this.opponentScore, this.opponentUsername, this.deck);

  static StatsRecord fromJson(Map<String, dynamic> jsonObject) => StatsRecord(
        jsonObject["date"],
        jsonObject["userScore"],
        jsonObject["opponentScore"],
        jsonObject["opponentUsername"],
        Deck.fromJson(jsonObject["deck"]),
      );

  Map<String, dynamic> toJson() => {
        "date": this.date,
        "userScore": this.userScore,
        "opponentScore": this.opponentScore,
        "opponentUsername": this.opponentUsername,
        "deck": this.deck.toJson(),
      };

  static List<StatsRecord> fromJsonArray(List<dynamic> jsonObj) =>
      List.from(jsonObj.map((jsonRecord) => StatsRecord.fromJson(jsonRecord)));

  static List<Map<String, dynamic>> toJsonArray(List<StatsRecord> records) =>
      List.from(records.map((record) => record.toJson()));
}
