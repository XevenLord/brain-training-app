import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackService {
  static Future<void> submitFeedback(String feedback) async {
    try {
      await FirebaseFirestore.instance.collection('feedback').add({
        'message': feedback,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw e;
    }
  }
}
