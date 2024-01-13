import 'package:brain_training_app/admin/patients/domain/entity/inspirational_mssg.dart';
import 'package:brain_training_app/main.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeService extends GetxService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static Future signOut() async {
    await _firebaseAuth.signOut();
    final appUser = Get.find<AppUser>();
    appUser.clear();
    secureStorage.deleteAll();
    // clear user uid stored in shared preference
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // fetch Inspirational Messages
  static Future<List<InspirationalMessage>> fetchInspirationalMessages() async {
    try {
      final appUser = Get.find<AppUser>();
      List<InspirationalMessage> inspirationalMessages = [];
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('inspirationalMssg')
          .doc(appUser.uid)
          .collection('inspirationalMssg')
          .get();

      inspirationalMessages = querySnapshot.docs.map((doc) {
        return InspirationalMessage.fromJson(
            doc.data()! as Map<String, dynamic>);
      }).toList();
      return inspirationalMessages;
    } catch (e) {
      // Handle exceptions
      print(e);
      return [];
    }
  }

  static Future<List<InspirationalMessage>>
      fetchGeneralInspirationalMessages() async {
    try {
      List<InspirationalMessage> inspirationalMessages = [];
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('inspirationalMssg')
          .doc('general')
          .collection('inspirationalMssg')
          .limit(3)
          .get();

      inspirationalMessages = querySnapshot.docs.map((doc) {
        return InspirationalMessage.fromJson(
            doc.data()! as Map<String, dynamic>);
      }).toList();
      return inspirationalMessages;
    } catch (e) {
      // Handle exceptions
      print(e);
      return [];
    }
  }

  // update readAt status of inspirational message
  static Future<void> updateReadAtStatus(String inspirationalMssgId) async {
    try {
      final appUser = Get.find<AppUser>();
      final inspirationalMssgRef = FirebaseFirestore.instance
          .collection('inspirationalMssg')
          .doc(appUser.uid)
          .collection('inspirationalMssg')
          .doc(inspirationalMssgId);

      await inspirationalMssgRef.update({
        'readAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating readAt status: $e');
    }
  }

  // update the lastInspired field of the user
  static Future<void> updateLastInspired() async {
    try {
      final appUser = Get.find<AppUser>();
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(appUser.uid);
      await userRef.update({'lastInspired': FieldValue.serverTimestamp()});
    } catch (e) {
      print('Error updating lastInspired status: $e');
    }
  }
}
