import 'package:brain_training_app/admin/games/flipcard/domain/entity/flipcard_set.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminFlipCardService {
  Future<List<FlipCardSet>> getFlipCardSetByUserId(String userId) async {
    try {
      List<FlipCardSet> flipCardResults = [];
      var querySnapshot = await FirebaseFirestore.instance
          .collection('games')
          .doc("FlipCard")
          .collection("users")
          .doc(userId)
          .collection("results")
          .get();

      print("Enter here service");

      flipCardResults = querySnapshot.docs.map((doc) {
        print(doc.data().toString());
        return FlipCardSet.fromJson(doc.data(), doc.id);
      }).toList();

      print(flipCardResults.toString());
      return flipCardResults;
    } catch (e) {
      print("Error Admin Flip Card Service: " + e.toString());
      return [];
    }
  }

  Future<List<String>> getFlipCardUserIdList() async {
    try {
      List<String> userIdList = [];

      userIdList = await FirebaseFirestore.instance
          .collection('games')
          .doc("FlipCard")
          .collection("users")
          .get()
          .then((value) => value.docs.map((e) => e.id).toList());

      print("Flip Card Service: " + userIdList.toString());
      return userIdList;
    } catch (e) {
      print("[Flip Card Service] Error getFlipCardUserIdList: " + e.toString());
      return [];
    }
  }
}
