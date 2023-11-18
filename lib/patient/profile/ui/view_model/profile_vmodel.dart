import 'dart:io';

import 'package:brain_training_app/patient/profile/domain/service/profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileViewModel extends GetxController implements GetxService {
  final ImagePicker _picker = ImagePicker();

  Rx<File?> imagefile = Rx<File?>(null);
  var _profilePicUrl;

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    bool isUpdated = false;
    Map<String, dynamic> newData = {};
    data.forEach((key, value) {
      if (value != "") newData[key] = value;
    });
    if (_profilePicUrl != null) newData['profilePic'] = _profilePicUrl;
    isUpdated = await ProfileService.onUpdateProfileDetails(newData);

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

  void _uploadFile() {
    if (imagefile == null) return;
    final storageRef = FirebaseStorage.instance.ref();
    final profileImagesRef = storageRef
        .child('${FirebaseAuth.instance.currentUser?.uid}/photos/profile.jpg');

    profileImagesRef
        .putFile(imagefile.value!)
        .snapshotEvents
        .listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          break;
        case TaskState.paused:
          break;
        case TaskState.success:
          profileImagesRef.getDownloadURL().then((value) {
            _profilePicUrl = value;
            update();
            print(_profilePicUrl + ": updated profile pic url");
          });
          break;
        case TaskState.error:
          break;
        case TaskState.canceled:
          break;
      }
    });
  }
}
