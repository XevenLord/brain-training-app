import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/service/auth_repo.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppConstant {
  // Image paths
  static const String NEUROFIT_LOGO = 'assets/images/logo-no-background.png';
  static const String NEUROFIT_LOGO_ONLY = 'assets/images/logo-color.png';
  static const String LOADING_GIF = 'assets/images/loading.gif';
  static const String ERROR_IMG = 'assets/images/error_symbol.png';
  static const String FORGET_PASSWORD = 'assets/images/forget_password.png';
  static const String DONE_CHECK = 'assets/images/signup_completed.png';
  static const String WRONG_MARK = 'assets/images/wrongmark.png';
  static const String EMPTY_DATA = 'assets/images/no-data.png';
  static const String NO_PROFILE_PIC = "assets/image/noProfilePic.jpg";
  static const String SUPPORTIVE_IMG = 'assets/images/supportive_img.png';

  // Game 1: Tic Tac Toe
  static const String TIC_TAC_TOE_O = 'assets/images/ttt_default_o.png';
  static const String TIC_TAC_TOE_X = 'assets/images/ttt_default_x.png';

  // Appointment
  static const String APPOINTMENT_SUCCESS =
      'assets/images/appointment_done.png';

  static Future<bool> loadResources() async {
    bool loaded = true;

    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: false,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    try {
      debugModePrint("null check getCurrentUser " +
          (FirebaseAuthRepository.getCurrentUser() == null).toString());
      debugModePrint("null check get find uid " +
          (Get.find<AppUser>().uid == null).toString());
      if (FirebaseAuthRepository.getCurrentUser() != null &&
          Get.find<AppUser>().uid == null) {
        debugModePrint("loadResources: loading get user details...");
        loaded = await FirebaseAuthRepository.getUserDetails(
            FirebaseAuthRepository.getCurrentUser()!.uid);
        if (!loaded) {
          debugModePrint("can't load cuz user token expired...");
          if (FirebaseAuthRepository.getCurrentUser() != null) {
            // FirebaseAuthRepository.getCurrentUser()!.delete();
            await FirebaseAuthRepository.signInWithStoredCredentials();
            return true;
          }
        }
      }
    } catch (e) {
      debugModePrint(e);
    }
    return loaded;
  }
}

displayLoadingData() {
  return Stack(
    children: [
      Center(
        child: CircularProgressIndicator(),
      ),
      Positioned(
        child: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
    ],
  );
}

displayEmptyDataLoaded(String message, Function()? onBack) {
  return Stack(
    children: [
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppConstant.EMPTY_DATA,
              height: 200,
              width: 200,
            ),
            SizedBox(height: 20.h),
            Text(message, style: AppTextStyle.h1),
          ],
        ),
      ),
      Positioned(
        child: IconButton(
          onPressed: onBack ?? () => Get.back(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
    ],
  );
}

void debugModePrint(Object? object) {
  if (kDebugMode) {
    print(object);
  }
}

enum Level { Easy, Medium, Hard }
