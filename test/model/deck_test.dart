import 'dart:convert';
import 'dart:math';

import 'package:congrega/features/profile_page/data/stats_repo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Deck", () {
    test("should convert to JSON", () {
      Deck d = new Deck(name: "deck_one");

      String jsonEncoded = jsonEncode(d.toJson());

      expect(d, Deck.fromJson(jsonDecode(jsonEncoded)));
    });

    test("should convert to json array", () {
      List<Deck> deckList = [Deck(name: "deck_one"), Deck(name: "deck_two")];

      String encodedList = jsonEncode(Deck.toJsonArray(deckList));

      expect(deckList, containsAll(Deck.listFromJson(jsonDecode(encodedList))));
    });
  });
}
