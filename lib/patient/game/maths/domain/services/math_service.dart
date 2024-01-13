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
        .collection("answers");

    try {
      String customDocumentId = DateFormat("yyyy-MM-dd").format(DateTime.now());

      var documentSnapshot = await mathDoc.doc(customDocumentId).get();
      print("Math Game Service: Submitting math quest ans part 2");
      if (documentSnapshot.exists) {
        await mathDoc.doc(customDocumentId).update({
          "answers": FieldValue.arrayUnion([
            {
              "correctAns": answers["correctAns"],
              "isUserCorrect": answers["isUserCorrect"],
              "question": answers["question"],
              "level": answers["level"],
              "userAnswer": answers["userAnswer"],
              "timestamp": DateTime.now(),
            }
          ]),
        });
      } else {
        // If the document doesn't exist, create it with the answers array
        print("part 3");
        await mathDoc.doc(customDocumentId).set({
          "answers": [
            {
              "correctAns": answers["correctAns"],
              "isUserCorrect": answers["isUserCorrect"],
              "question": answers["question"],
              "level": answers["level"],
              "userAnswer": answers["userAnswer"],
              "timestamp": DateTime.now(),
            }
          ],
        });
      }

      return true;
    } on FirebaseException catch (e) {
      print("Math Game Service: Updating math quest ans error: $e");
      return false; // Return null in case of an error
    }
  }
}
