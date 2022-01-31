import 'deck.dart';

class StatsRecord {
  DateTime date;
  int userScore;
  int opponentScore;
  String opponentUsername;
  Deck deck;

  StatsRecord(this.date, this.userScore, this.opponentScore, this.opponentUsername, this.deck);
}
