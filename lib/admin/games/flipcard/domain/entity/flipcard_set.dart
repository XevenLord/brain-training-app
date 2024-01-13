import 'package:brain_training_app/admin/games/flipcard/domain/entity/flipcard_result.dart';

class FlipCardSet {
  String? id;
  List<FlipCardResult>? flipCards;

  FlipCardSet({this.flipCards, this.id});

  factory FlipCardSet.fromJson(Map<String, dynamic> json, String? id) {
    return FlipCardSet(
      id: id,
      flipCards: FlipCardResult.fromJsonList(json["results"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'flipCards': flipCards,
    };
  }

  setFlipCards(List<FlipCardResult> flipCards) {
    this.flipCards = flipCards;
  }
}