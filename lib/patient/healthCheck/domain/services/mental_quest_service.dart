import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MentalQuestService {
  static Future<bool> submitMentalHealthAnswer(
      Map<String, String> answers) async {
    final appUser = Get.find<AppUser>();
    try {
      await FirebaseFirestore.instance
          .collection("mentals")
          .doc(appUser.uid)
          .set({DateFormat('yyyy-MM-dd').format(DateTime.now()): answers});

      // Return the UID of the document created/updated
      return true;
    } on FirebaseException catch (e) {
      print("Mental Quest Service: Updating mental quiz error");
      return false; // Return null in case of an error
    }
  }

  static Future<Map<String, dynamic>> getMentalHealthAnswerByID(String uid) async {
    try {
      print("Mental Quest Service: Getting mental quiz");
      print("app user id: ${uid}");
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection("mentals")
          .doc(uid)
          .get();
      print("doc: ${doc.data()}");
      if (doc.data() == null) {
        return {};
      }
      return doc.data()!;
    } on FirebaseException catch (e) {
      print("Mental Quest Service: Getting mental quiz error");
      return {}; // Return null in case of an error
    }
  }
}
