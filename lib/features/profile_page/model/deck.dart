import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Deck extends Equatable {
  static const String PREDIFINED_DECK_UUID = "419e27c0-82b8-11ec-9848-f7b2f5afc1c6";
  final String name;
  final String id;

  Deck({required this.name, id}) : this.id = id ?? Uuid().v4();

  @override
  List<Object?> get props => [id, name];

  static Deck empty() => Deck(name: "Predifined", id: "predifined");

  Deck copyWith({String? name, String? id}) => Deck(name: name ?? this.name, id: id ?? this.id);

  static Deck fromJson(Map<String, dynamic> jsonObj) =>
      Deck(name: jsonObj["name"], id: jsonObj["id"]);

  Map<String, dynamic> toJson() => {"id": this.id, "name": this.name};

  static List<Deck> listFromJson(List<dynamic> jsonObj) {
    return List.from(jsonObj.map((jsonDeck) => Deck.fromJson(jsonDeck)));
  }

  static List<Map<String, dynamic>> toJsonArray(List<Deck> deckList) {
    return List.from(deckList.map((deck) => deck.toJson()));
  }
}
