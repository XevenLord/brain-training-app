import 'package:brain_training_app/common/domain/entity/tzfe_score_set.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TZFEService {
  static Future<void> submitScore(
      int score, String status, Duration? duration) async {
    final appUser = Get.find<AppUser>();

    final collectionRef = FirebaseFirestore.instance
        .collection('games')
        .doc('TZFE')
        .collection('users');

    collectionRef.doc(appUser.uid).set({'uid': appUser.uid});

    final tzfeDoc = collectionRef.doc(appUser.uid).collection("scores");

    try {
      String customDocumentId = DateFormat("yyyy-MM-dd").format(DateTime.now());

      var documentSnapshot = await tzfeDoc.doc(customDocumentId).get();
      if (documentSnapshot.exists) {
        await tzfeDoc.doc(customDocumentId).update({
          "scores": FieldValue.arrayUnion([
            {
              "score": score,
              "status": status,
              "duration": duration?.inSeconds,
              "timestamp": DateTime.now(),
            }
          ]),
        });
      } else {
        await tzfeDoc.doc(customDocumentId).set({
          "scores": [
            {
              "score": score,
              "status": status,
              "duration": duration?.inSeconds,
              "timestamp": DateTime.now(),
            }
          ]
        });
      }
    } catch (e) {
      print("TZFE Service: Updating tzfe score error: $e");
    }
  }

  static Future<List<TZFEScoreSet>> getTZFEScores() async {
    try {
      final appUser = Get.find<AppUser>();
      List<TZFEScoreSet> tZFEScoreSet = [];
      var querySnapshot = await FirebaseFirestore.instance
          .collection('games')
          .doc("TZFE")
          .collection("users")
          .doc(appUser.uid)
          .collection("scores")
          .get();

      tZFEScoreSet = querySnapshot.docs
          .map((doc) => TZFEScoreSet.fromJson(doc.data(), doc.id))
          .toList();

      print(tZFEScoreSet.toString());
      return tZFEScoreSet;
    } catch (e) {
      print("Error Math Service: " + e.toString());
      return [];
    }
  }
}
