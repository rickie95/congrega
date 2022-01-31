import 'package:equatable/equatable.dart';

class Deck extends Equatable {
  final String name;

  const Deck({required this.name});

  @override
  List<Object?> get props => [name];

  static Deck empty() => Deck(name: "Predifined");

  static Deck fromJson(Map<String, dynamic> jsonObj) => Deck(name: jsonObj["name"]);

  Map<String, dynamic> toJson() => {"name": this.name};

  static List<Deck> listFromJson(List<dynamic> jsonObj) {
    return List.from(jsonObj.map((jsonDeck) => Deck.fromJson(jsonDeck)));
  }

  static List<Map<String, dynamic>> toJsonArray(List<Deck> deckList) {
    return List.from(deckList.map((deck) => deck.toJson()));
  }
}
