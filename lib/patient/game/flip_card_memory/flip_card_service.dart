import 'package:brain_training_app/admin/games/flipcard/domain/entity/flipcard_set.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/game/flip_card_memory/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FlipCardService {
  static Future<void> submitFlipCardRecord(int time, Level level) async {
    final appUser = Get.find<AppUser>();

    final collectionRef = FirebaseFirestore.instance
        .collection('games')
        .doc('FlipCard')
        .collection('users');

    // Create the 'users' collection if it doesn't exist.
    collectionRef.doc(appUser.uid).set({'uid': appUser.uid});

    final flipCardDoc = collectionRef.doc(appUser.uid).collection("results");

    try {
      String customDocumentId = DateFormat("yyyy-MM-dd").format(DateTime.now());

      var documentSnapshot = await flipCardDoc.doc(customDocumentId).get();
      if (documentSnapshot.exists) {
        await flipCardDoc.doc(customDocumentId).update({
          "results": FieldValue.arrayUnion([
            {
              "second": time,
              "level": level.toString().split('.').last,
              "timestamp": DateTime.now(),
            }
          ]),
        });
      } else {
        // If the document doesn't exist, create it with the answers array
        await flipCardDoc.doc(customDocumentId).set({
          "results": [
            {
              "second": time,
              "level": level.toString().split('.').last,
              "timestamp": DateTime.now(),
            }
          ]
        });
      }
    } on FirebaseException catch (e) {
      print("Flip Card Service: Updating flip card record error: $e");
    }
  }

  static Future<List<FlipCardSet>> getFlipCardSet() async {
    try {
      final appUser = Get.find<AppUser>();
      List<FlipCardSet> flipCardResults = [];
      var querySnapshot = await FirebaseFirestore.instance
          .collection('games')
          .doc("FlipCard")
          .collection("users")
          .doc(appUser.uid)
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
      print("Error Flip Card Service: " + e.toString());
      return [];
    }
  }
}
