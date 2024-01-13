import 'package:brain_training_app/admin/mmse/domain/entity/option.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String id;
  final String question;
  String? pdfRef;
  final List<Option> options;

  Question(
      {required this.question,
      required this.options,
      required this.id,
      this.pdfRef});

  factory Question.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Question(
      id: data['id'],
      question: data['question'],
      options: List<Option>.from(
          data['options'].map((option) => Option(text: option))),
      pdfRef: data['pdfRef'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options.map((option) => option.toJson()).toList(),
      'pdfRef': pdfRef,
      'id': id,
    };
  }
}
