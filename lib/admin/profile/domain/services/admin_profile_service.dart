import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/service/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AdminProfileService {
  static Future<bool> onUpdateProfileDetails(Map<String, dynamic> data) async {
    final appUser = Get.find<AppUser>();
    try {
      bool res = await FirebaseFirestore.instance
          .collection('users')
          .doc(appUser.uid)
          .update(data)
          .then((value) => true)
          .catchError((error) => false);
      data.forEach((key, value) {
        if (value == "") deleteDataInProfile(key);
      });
      await FirebaseAuthRepository.getUserDetails(appUser.uid!);
      return res;
    } catch (e) {
      return Future.value(false);
    }
  }

  static Future<bool> deleteDataInProfile(String key) async {
    final appUser = Get.find<AppUser>();
    try {
      bool res = await FirebaseFirestore.instance
          .collection('users')
          .doc(appUser.uid)
          .update({key: FieldValue.delete()})
          .then((value) => true)
          .catchError((error) => false);
      await FirebaseAuthRepository.getUserDetails(appUser.uid!);
      return res;
    } catch (e) {
      return Future.value(false);
    }
  }

  static Future<bool> updateNameInChats(String name) {
    final appUser = Get.find<AppUser>();
    try {
      FirebaseFirestore.instance
          .collection('chats')
          .where('users.${appUser.uid}', isNull: true)
          .get()
          .then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          Map<String, dynamic> names = data['names'];
          names[appUser.uid!] = name;
          doc.reference.update({'names': names});
        });
      });
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }
}
