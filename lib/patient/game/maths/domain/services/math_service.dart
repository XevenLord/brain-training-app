import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MathGameService {
  static Future<bool> submitQuestionWithAnswer(
      Map<String, dynamic> answers) async {
    print("Math Game Service: Submitting math quest ans");
    final appUser = Get.find<AppUser>();
    final mathDoc = FirebaseFirestore.instance
        .collection("games")
        .doc("MathGame")
        .collection("users")
        .doc(appUser.uid)
        .collection("answers"); // Create a subcollection for answers

    try {
      String customDocumentId =
          DateTime.now().toUtc().millisecondsSinceEpoch.toString();

      await mathDoc.doc(customDocumentId).set({
        "answer": answers,
        "timestamp": FieldValue.serverTimestamp(),
      });

      return true;
    } on FirebaseException catch (e) {
      print("Math Game Service: Updating math quest ans error");
      return false; // Return null in case of an error
    }
  }
}
