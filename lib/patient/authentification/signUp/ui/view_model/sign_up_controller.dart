import 'dart:io';

import 'package:brain_training_app/patient/authentification/signUp/domain/service/auth_repo.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/use_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SignUpController extends GetxController {
  Map<String, dynamic> _userDetails = {};
  Map get userDetails => _userDetails;
  final ImagePicker _picker = ImagePicker();
  Rx<File?> imagefile = Rx<File?>(null);
  var _profilePicUrl;

  void setFormData(Map<String, dynamic> data) {
    for (var element in data.entries) {
      _userDetails[element.key] = element.value;
    }
  }

  void signUpWithData(Map<String, dynamic> data) async {
    UserCredential? signUpRes =
        await FirebaseAuthRepository.signUpWithEmailAndPassword(
      email: _userDetails['email'],
      password: data['password'],
    );

    if (signUpRes == null) {
      killDialog();
      useErrorDialog(
          title: "Oops! Something went wrong",
          titleStyle: AppTextStyle.h2,
          description:
              "An error occurred while creating your account. Please try again later.",
          descriptionStyle: AppTextStyle.c1);
      return;
    }

    try {
      await _uploadFile();
      if (_profilePicUrl != null) _userDetails['profilePic'] = _profilePicUrl;

      User newUser = signUpRes.user!;
      bool initRes = await Get.find<FirebaseAuthRepository>()
          .initUserDataWithUID(newUser.uid, _userDetails);

      if (!initRes) {
        // If initUserDataWithUID is unsuccessful, delete the user credentials
        await newUser.delete();
        killDialog();
        useErrorDialog(
            title: "Oops! Something went wrong",
            titleStyle: AppTextStyle.h2,
            description:
                "An error occurred while creating your account. Please try again later.",
            descriptionStyle: AppTextStyle.c1);
        return;
      }

      _userDetails.clear();
      killDialog();
      Get.toNamed(RouteHelper.getSignUpDonePage());
    } catch (e) {
      // Handle any exceptions that may occur during registration, file upload, or initialization
      print("Error during registration, file upload, or initialization: $e");
      killDialog();
      useErrorDialog(
          title: "Oops! Something went wrong",
          titleStyle: AppTextStyle.h2,
          description:
              "An error occurred while creating your account. Please try again later.",
          descriptionStyle: AppTextStyle.c1);
    }
  }

  Future<bool> adminSignUpWithData(Map<String, dynamic> data) async {
    print(data);

    try {
      UserCredential signUpRes = await FirebaseAuthRepository.registerAdmin(
        email: data['email'],
        password: data['password'],
      );

      await _uploadFile();
      if (_profilePicUrl != null) data['profilePic'] = _profilePicUrl;

      data.addAll({"role": "admin"});
      data.addAll({"position": "Assistant"});

      User newUser = signUpRes.user!;

      bool initRes = await Get.find<FirebaseAuthRepository>()
          .initUserDataWithUID(newUser.uid, data, setUserDetails: false);

      if (!initRes) {
        // If initUserDataWithUID is unsuccessful, delete the user credentials
        await newUser.delete();
        killDialog();
        useErrorDialog(
            title: "Oops! Something went wrong",
            titleStyle: AppTextStyle.h2,
            description:
                "An error occurred while creating your account. Please try again later.",
            descriptionStyle: AppTextStyle.c1);
        return false;
      }

      killDialog();
      return initRes;
    } catch (e) {
      // Handle any exceptions that may occur during registration or initialization
      print("Error during registration or initialization: $e");
      killDialog();
      useErrorDialog(
          title: "Oops! Something went wrong",
          titleStyle: AppTextStyle.h2,
          description:
              "An error occurred while creating your account. Please try again later.",
          descriptionStyle: AppTextStyle.c1);
      return false;
    }
  }

  // Taking Image
  void takeImageFromCamera() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image != null) {
      imagefile.value = File(image.path);
    } else {
      print('Image capture failed.');
    }
  }

  void takeImageFromGallery() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      imagefile.value = File(image.path);
    } else {
      print('Image capture failed.');
    }
  }

  Future<void> _uploadFile() async {
    if (imagefile.value == null) return;
    final storageRef = FirebaseStorage.instance.ref();
    final profileImagesRef = storageRef
        .child('${FirebaseAuth.instance.currentUser?.uid}/photos/profile.jpg');

    final uploadTask = profileImagesRef.putFile(imagefile.value!);

    // Wait for the upload to complete before proceeding
    await uploadTask.whenComplete(() async {
      try {
        final downloadUrl = await profileImagesRef.getDownloadURL();
        _profilePicUrl = downloadUrl;
        update();
        print(_profilePicUrl + ": updated profile pic url");

        // Now that the URL is available, you can update _userDetails
        if (_profilePicUrl != null) _userDetails['profilePic'] = _profilePicUrl;
        imagefile.value = null;
      } catch (error) {
        // Handle any errors that occurred during URL retrieval
        print("Error getting download URL: $error");
      }
    });
  }
}
