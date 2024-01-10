import 'dart:io';

import 'package:brain_training_app/admin/profile/domain/services/admin_profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AdminProfileViewModel extends GetxController implements GetxService {
  final ImagePicker _picker = ImagePicker();

  Rx<File?> imagefile = Rx<File?>(null);
  var _profilePicUrl;

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    bool isUpdated = false;
    Map<String, dynamic> newData = {};
    data.forEach((key, value) async {
      if (value != "") newData[key] = value;
      if (key == "name") {
        await AdminProfileService.updateNameInChats(value);
      }
    });
    if (_profilePicUrl != null) newData['profilePic'] = _profilePicUrl;
    isUpdated = await AdminProfileService.onUpdateProfileDetails(newData);
    update();
    return isUpdated;
  }

  void takeImageFromCamera() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image != null) {
      imagefile.value = File(image.path);
      _uploadFile();
    } else {
      print('Image capture failed.');
    }
  }

  void takeImageFromGallery() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      imagefile.value = File(image.path);
      _uploadFile();
    } else {
      print('Image capture failed.');
    }
  }

  Future<void> _uploadFile() async {
    if (imagefile.value == null) return;
    final storageRef = FirebaseStorage.instance.ref();
    final profileImagesRef = storageRef
        .child('${FirebaseAuth.instance.currentUser?.uid}/photos/profile.jpg');

    await profileImagesRef.putFile(imagefile.value!).whenComplete(() async {
      _profilePicUrl = await profileImagesRef.getDownloadURL();
    });
  }
}
