import 'package:brain_training_app/admin/mmse/domain/entity/patient_response.dart';
import 'package:brain_training_app/admin/mmse/domain/entity/question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class MMSEService {
  static Future<List<Question>> loadQuestions() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('mmse')
          .doc('questions')
          .collection('questions')
          .get();
      return querySnapshot.docs
          .map((doc) => Question.fromSnapshot(doc))
          .toList();
    } catch (e) {
      print('Error loading questions: $e');
      return [];
    }
  }

  static Future<void> submitAnswer(
      List<Map<String, dynamic>> answers, int score, String uid) async {
    try {
      final timestamp = DateTime.now();
      final documentId =
          timestamp.toUtc().toIso8601String(); // Generate a unique ID.

      final responseCollectionRef = FirebaseFirestore.instance
          .collection('mmse')
          .doc('responses')
          .collection('responses');

      // Create the 'response' collection if it doesn't exist.
      responseCollectionRef.doc(uid).set({'uid': uid});

      final responseDocRef =
          responseCollectionRef.doc(uid).collection('response').doc(documentId);

      await responseDocRef.set({
        'answers': answers,
        'score': score,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('Answers submitted successfully!');
    } catch (e) {
      print('Error submitting answers: $e');
    }
  }

  static Future<List<PatientResponse>> loadPatientResponses() async {
    List<PatientResponse> allPatientResponses = [];

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('mmse')
          .doc('responses')
          .collection('responses')
          .get();

      for (final docu in querySnapshot.docs) {
        final responseCollection = docu.reference.collection('response');
        final responses = await responseCollection.get();

        final patientResponses = responses.docs
            .map((doc) => PatientResponse.fromSnapshot(doc, docu.id))
            .toList();

        allPatientResponses.addAll(patientResponses);
      }

      return allPatientResponses;
    } catch (e) {
      print('Service Error loading patient responses: $e');
      return [];
    }
  }
}
