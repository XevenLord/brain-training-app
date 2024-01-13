import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackData {
  final String id;
  final String message;
  final Timestamp timestamp;

  FeedbackData(
      {required this.message, required this.timestamp, required this.id});

  factory FeedbackData.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return FeedbackData(
      id: snapshot.id,
      message: data['message'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}
