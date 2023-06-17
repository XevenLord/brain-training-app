import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/service/auth_repo.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/use_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class SignUpController {
  // mcm can change to dynamic map will be better
  Map<String, dynamic> _userDetails = {};

  void setFormData(Map<String, dynamic> data) {
    for (var element in data.entries) {
      _userDetails[element.key] = element.value;
    }
  }

  void signUpWithData(Map<String, dynamic> data) async {
    UserCredential signUpRes =
        await FirebaseAuthRepository.signUpWithEmailAndPassword(
      email: _userDetails['email'],
      password: data['password'],
    );

    debugPrint("1. sign up result: ${signUpRes}");

    User newUser = signUpRes.user!;

    bool initRes = await Get.find<FirebaseAuthRepository>()
        .initUserDataWithUID(newUser.uid, _userDetails);

    debugPrint("2. firebase write result: ${initRes}");

    if (!initRes) {
      killDialog();
      useErrorDialog(
          title: "Oops! Something went wrong",
          titleStyle: AppTextStyle.h2,
          description:
              "An error occurred while creating your account. Please try again later.",
          descriptionStyle: AppTextStyle.c1);

      return;
    }
    killDialog();
    Get.toNamed(RouteHelper.getSignUpDonePage());
    // await newUser.sendEmailVerification();
    // Get.toNamed(RouteHelper.getVerifyEmailPage(),
    //       parameters: {"email": email});

    //   return;
  }
}
