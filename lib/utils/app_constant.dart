import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/service/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AppConstant {
  // Image paths
  static const String NEUROFIT_LOGO = 'assets/images/logo-no-background.png';
  static const String NEUROFIT_LOGO_ONLY = 'assets/images/logo-color.png';
  static const String LOADING_GIF = 'assets/images/loading.gif';
  static const String ERROR_IMG = 'assets/images/error.png';
  static const String FORGET_PASSWORD = 'assets/images/forget_password.png';
  static const String DONE_CHECK = 'assets/images/signup_completed.png';
  static const String WRONG_MARK = 'assets/images/wrongmark.png';
  
  // Game 1: Tic Tac Toe
  static const String TIC_TAC_TOE_O = 'assets/images/ttt_default_o.png';
  static const String TIC_TAC_TOE_X = 'assets/images/ttt_default_x.png';

  // Appointment
  static const String APPOINTMENT_SUCCESS = 'assets/images/appointment_done.png';

  static Future<bool> loadResources() async {
    bool loaded = true;

    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: false,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    try {
        if (FirebaseAuthRepository.getCurrentUser() != null && Get.find<AppUser>().uid == null) {
          loaded = await FirebaseAuthRepository.getUserDetails(FirebaseAuthRepository.getCurrentUser()!.uid);
          if(!loaded) {
            if(FirebaseAuthRepository.getCurrentUser() != null) {
              FirebaseAuthRepository.getCurrentUser()!.delete();
              return true;
            }
          }
        }
      } catch (e) {
        debugPrint(e);
      }
    return loaded;
  }


}

void debugPrint(Object? object) {
  if (kDebugMode) {
    print(object);
  }
}