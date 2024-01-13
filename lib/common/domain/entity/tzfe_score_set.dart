import 'package:brain_training_app/common/domain/entity/tzfe_score.dart';

class TZFEScoreSet {
  String? id;
  List<TZFEScore> tzfeScores;

  TZFEScoreSet({this.tzfeScores = const [], this.id});

  factory TZFEScoreSet.fromJson(Map<String, dynamic> json, String? id) {
    return TZFEScoreSet(
      id: id,
      tzfeScores: TZFEScore.fromJsonList(json["scores"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scores': tzfeScores,
    };
  }

  setTZFEScores(List<TZFEScore> tzfeScores) {
    this.tzfeScores = tzfeScores;
  }
}
