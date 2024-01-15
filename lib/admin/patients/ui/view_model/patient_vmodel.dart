import 'dart:io';

import 'package:brain_training_app/admin/patients/domain/entity/inspirational_mssg.dart';
import 'package:brain_training_app/admin/patients/domain/services/manage_patient_service.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ManagePatientViewModel extends GetxController {
  AppUser? _patient;
  AppUser? get patient => _patient;

  Map<String, dynamic> _userDetails = {};
  final ImagePicker _picker = ImagePicker();
  Rx<File?> imagefile = Rx<File?>(null);
  var _pictureUrl;

  void setPatient(AppUser patient) {
    _patient = patient;
    update();
  }

  void setDetails(Map<String, dynamic> userDetails) {
    _userDetails = userDetails;
    update();
  }

  Future<bool> onPushInspirationalMessage() async {
    bool isUpdated = false;
    Map<String, dynamic> newData = {};
    _userDetails.forEach((key, value) async {
      if (value != "") newData[key] = value;
    });

    await _uploadFile();
    if (_pictureUrl != null) newData['imgUrl'] = _pictureUrl;

    InspirationalMessage message = InspirationalMessage.fromJson(newData);
    isUpdated = await ManagePatientService.onPushInspirationalMessage(message);
    _pictureUrl = null;
    _userDetails.clear();
    update();
    return isUpdated;
  }

  Future<List<InspirationalMessage>> getInspirationalMessagesByUser(
      String userId) async {
    try {
      final inspirationalMessages =
          await ManagePatientService.getInspirationalMessagesByUser(userId);
      return inspirationalMessages;
    } catch (e) {
      return [];
    }
  }

  Future<List<InspirationalMessage>> getGeneralInspirationalMessages() async {
    try {
      final inspirationalMessages =
          await ManagePatientService.getGeneralInspirationalMessages();
      return inspirationalMessages;
    } catch (e) {
      return [];
    }
  }

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

    final String? userUID = patient?.uid;
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String uniquePath = '$userUID/photos/profile_$timestamp.jpg';
    final insImgRef = storageRef.child(uniquePath);

    final uploadTask = insImgRef.putFile(imagefile.value!);

    await uploadTask.whenComplete(() async {
      try {
        final downloadUrl = await insImgRef.getDownloadURL();
        _pictureUrl = downloadUrl;
        update();

        if (_pictureUrl != null) _userDetails['profilePic'] = _pictureUrl;
        imagefile.value = null;
      } catch (error) {
        // Handle any errors that occurred during URL retrieval
        print("Error getting download URL: $error");
      }
    });
  }

  Future<bool> assignPatient(AppUser patient) async {
    try {
      bool isAssigned = false;
      if (patient.assignedTo != null) return isAssigned;
      isAssigned = await ManagePatientService.assignPatient(patient.uid!);
      return isAssigned;
    } catch (e) {
      return false;
    }
  }

  Future<bool> unassignPatient(AppUser patient) async {
    try {
      bool isUnassigned = false;
      if (patient.assignedTo == null ||
          patient.assignedTo != Get.find<AppUser>().uid) return isUnassigned;
      isUnassigned = await ManagePatientService.unassignPatient(patient.uid!);
      return isUnassigned;
    } catch (e) {
      return false;
    }
  }
}
