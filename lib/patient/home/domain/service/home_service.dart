import 'package:brain_training_app/main.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
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
}
