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
          .set({'uid': appUser.uid});

      await FirebaseFirestore.instance
          .collection("mentals")
          .doc(appUser.uid)
          .collection("mentals")
          .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
          .set({DateFormat('yyyy-MM-dd').format(DateTime.now()): answers});

      // Return the UID of the document created/updated
      return true;
    } on FirebaseException catch (e) {
      print("Mental Quest Service: Updating mental quiz error ${e.message}");
      return false; // Return null in case of an error
    }
  }

  static Future<Map<String, dynamic>> getMentalHealthAnswerByID(
      String uid) async {
    try {
      Map<String, dynamic> mentalResult = {};
      print("Mental Quest Service: Getting mental quiz");
      print("app user id: ${uid}");
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection("mentals")
              .doc(uid)
              .collection("mentals")
              .get();

      querySnapshot.docs.forEach((element) {
        mentalResult.addAll(element.data());
      });
      print("Mental Quest Service: Getting mental quiz ${mentalResult}");

      return mentalResult;
    } on FirebaseException catch (e) {
      print("Mental Quest Service: Getting mental quiz error");
      return {}; // Return null in case of an error
    }
  }
}
