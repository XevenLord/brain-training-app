import 'dart:io';

import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/chat/domain/service/chat_room_controller_unilah.dart';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ChatPrepSendViewModel extends GetxController {
  final appUserController = Get.find<AppUser>();
  final chatRoomController = Get.find<ChatRoomController>();
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> sendImage(chatId, friendUid, XFile image, imagePath) async {
    debugPrint("Sending image from camera");
    debugPrint("all data ${chatId}, ${friendUid}, ${image.name}, ${imagePath}");
    try {
      File imageFile = await chatRoomController.compressFile(File(image.path));
      debugPrint("Image Compressed");
      String? photoUrl = await chatRoomController.uploadImage(imageFile, friendUid);
      debugPrint("photoUrl ${photoUrl}");
      chatRoomController.newChat(
          chatId, friendUid, photoUrl ?? "Image fail to Upload", "Image");
    } catch (e) {
      debugPrint(e.toString());
    }
    Get.back();
    Get.back();
    await File(imagePath).delete();
  }

  Future<void> deleteFile(imagePath) async {
    Get.back();
    await File(imagePath).delete();
  }
}
