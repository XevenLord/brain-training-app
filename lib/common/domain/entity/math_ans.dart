import 'package:cloud_firestore/cloud_firestore.dart';

class MathAnswer {
  String? correctAns;
  bool? isUserCorrect;
  String? level;
  String? question;
  String? userAnswer;
  Timestamp? timestamp;

  MathAnswer({
    this.correctAns,
    this.isUserCorrect,
    this.level,
    this.question,
    this.userAnswer,
    this.timestamp,
  });

  factory MathAnswer.fromJson(Map<String, dynamic> json) {
    return MathAnswer(
      correctAns: json["correctAns"],
      isUserCorrect: json["isUserCorrect"],
      level: json["level"],
      question: json["question"],
      userAnswer: json["userAnswer"],
      timestamp: json["timestamp"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'correctAns': correctAns,
      'isUserCorrect': isUserCorrect,
      'level': level,
      'question': question,
      'userAnswer': userAnswer,
      'timestamp': timestamp,
    };
  }
}