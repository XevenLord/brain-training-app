import 'package:brain_training_app/admin/feedback/domain/entity/feedback.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackService {
  static Future<List<FeedbackData>> fetchFeedbackData() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('feedback')
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => FeedbackData.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw e;
    }
  }

  static Future<void> deleteFeedback(String feedbackId) async {
    try {
      // Reference to the feedback document
      final feedbackDocRef =
          FirebaseFirestore.instance.collection('feedback').doc(feedbackId);

      // Delete the feedback document
      await feedbackDocRef.delete();
    } catch (e) {
      throw e;
    }
  }
}
