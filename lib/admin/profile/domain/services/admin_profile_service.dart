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
      print("See profileeee");
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
      print("See profileeee");
      return res;
    } catch (e) {
      return Future.value(false);
    }
  }
}
