import 'package:cloud_firestore/cloud_firestore.dart';

class TZFEScore {
  int score;
  String status;
  int? duration;
  Timestamp? timestamp;

  TZFEScore({
    required this.score,
    required this.status,
    this.duration,
    this.timestamp,
  });

  factory TZFEScore.fromJson(Map<String, dynamic> json) {
    return TZFEScore(
      score: json['score'],
      status: json['status'],
      duration: json['duration'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'status': status,
      'duration': duration,
      'timestamp': timestamp,
    };
  }

  static List<TZFEScore> fromJsonList(List<dynamic> json) {
    List<TZFEScore> tzfeScores = [];
    json.forEach((element) {
      tzfeScores.add(TZFEScore.fromJson(element));
    });
    return tzfeScores;
  }
}
