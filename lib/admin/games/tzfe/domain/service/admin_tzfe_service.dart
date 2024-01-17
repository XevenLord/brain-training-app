import 'package:brain_training_app/common/domain/entity/tzfe_score_set.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminTZFEService {
  static Future<List<TZFEScoreSet>> getTZFEScoreSetByUserId(String userId) async {
    try {
      List<TZFEScoreSet> tZFEScoreSet = [];
      var querySnapshot = await FirebaseFirestore.instance
          .collection('games')
          .doc("TZFE")
          .collection("users")
          .doc(userId)
          .collection("scores")
          .get();

      tZFEScoreSet = querySnapshot.docs
          .map((doc) => TZFEScoreSet.fromJson(doc.data(), doc.id))
          .toList();

      print(tZFEScoreSet.toString());
      return tZFEScoreSet;
    } catch (e) {
      print("Error Admin TZFE Service: " + e.toString());
      return [];
    }
  }

  static Future<List<String>> getTZFEUserIdList() async {
    try {
      List<String> userIdList = [];

      userIdList = await FirebaseFirestore.instance
          .collection('games')
          .doc("TZFE")
          .collection("users")
          .get()
          .then((value) => value.docs.map((e) => e.id).toList());

      print("Admin TZFE Service: " + userIdList.toString());
      return userIdList;
    } catch (e) {
      print("[Admin TZFE Service] Error getMathUserIdList: " + e.toString());
      return [];
    }
  }
}
