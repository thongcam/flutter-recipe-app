import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';

class Recipe {
  String id;
  String name;
  bool vegan;
  String meal;
  int minutes;
  Delta richTextDelta;

  Map toJson() => {
        "id": id,
        "name": name,
        "vegan": vegan,
        "minutes": minutes,
        "meal": meal,
        "richTextJson": richTextDelta.toJson(),
      };

  factory Recipe.fromJson(Map json) {
    return Recipe(
        id: json["id"],
        name: json["name"],
        vegan: json["vegan"],
        minutes: json["minutes"],
        meal: json["meal"],
        richTextDelta: Document.fromJson(json["richTextJson"]).toDelta());
  }

  Recipe(
      {required this.id,
      required this.name,
      required this.vegan,
      required this.minutes,
      required this.meal,
      required this.richTextDelta});
}
