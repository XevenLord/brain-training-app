import 'dart:async';
import 'dart:io';

import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/chat/domain/service/audiio_controller.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:path_provider/path_provider.dart';

class ChatRoomController extends GetxController {
  late TextEditingController chatC;
  late ScrollController scrollC;
  late ImagePicker imagePicker;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final appUserController = Get.find<AppUser>();
  final audioController = Get.find<AudioController>();
  FirebaseStorage storage = FirebaseStorage.instance;

  RxBool hideCamera = true.obs;
  int totalUnread = 0;

  void newChat(
      String chatId, String friendUid, String message, String type) async {
    CollectionReference chats = firestore.collection("chats");
    CollectionReference users = firestore.collection("users");
    String date = DateTime.now().toIso8601String();

    if (message != "") {
      // final msg = chatC.text;
      chatC.clear();

      //update chat in the collection chats
      final newChat = await chats.doc(chatId).collection("chat").add({
        "sender": appUserController.uid,
        "receiver": friendUid,
        "message": message,
        "type": type,
        "time": date,
        "isRead": false
      });

      Timer(Duration.zero, () {
        scrollC.jumpTo(scrollC.position.maxScrollExtent);
      });

      //Update user database
      await users
          .doc(appUserController.uid)
          .collection("userChat")
          .doc(chatId)
          .update({
        "lastTime": date,
        "lastContent": type == "Image"
            ? "Image"
            : type == "Voice"
                ? "Voice"
                : message,
        "lastSender": appUserController.uid
      });

      //update friends database, need to check whether the
      //Chat collection exists or not
      final checkChatFriends =
          await users.doc(friendUid).collection("userChat").doc(chatId).get();

      if (checkChatFriends.exists) {
        //The chat collection exists, update the userChat collection
        //Query for existing unread
        final checkTotalUnread = await chats
            .doc(chatId)
            .collection("chat")
            .where("isRead", isEqualTo: false)
            .where("sender", isEqualTo: appUserController.uid)
            .get();

        //total unread for friend
        // debugModePrint("unread" + checkTotalUnread.docs.length.toString());
        totalUnread = checkTotalUnread.docs.length;

        //Update friends database
        await users.doc(friendUid).collection("userChat").doc(chatId).update({
          "lastTime": date,
          "lastContent": type == "Image"
              ? "Image"
              : type == "Voice"
                  ? "Voice"
                  : message,
          "lastSender": appUserController.uid,
          "totalUnread": totalUnread
        });
      } else {
        //create new chat collection because it didn't exists
        await users.doc(friendUid).collection("userChat").doc(chatId).set({
          "connection": appUserController.uid,
          "chatId": chatId,
          "lastTime": date,
          "lastContent": type == "Image"
              ? "Image"
              : type == "Voice"
                  ? "Voice"
                  : message,
          "lastSender": appUserController.uid,
          "totalUnread": 1
        });
      }
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamChats(String? chatId) {
    if (chatId == null) {
      return const Stream.empty();
    } else {
      CollectionReference chats = firestore.collection("chats");
      return chats
          .doc(chatId)
          .collection("chat")
          .orderBy("time", descending: false)
          .snapshots();
    }
  }

  //=============================Pick Image===================================
  void selectImage(String chatId, String friendUid) async {
    try {
      final List<XFile> images =
          await imagePicker.pickMultiImage(imageQuality: 50);

      debugModePrint("Image Selected");

      for (var i in images) {
        File imageFile = await compressFile(File(i.path));
        debugModePrint("Image Compressed");
        String? photoUrl = await uploadImage(imageFile, friendUid);
        debugModePrint("Image Uploaded $photoUrl");
        //do a new chat
        newChat(chatId, friendUid, photoUrl ?? "Image fail to Upload", "Image");
      }
    } catch (e) {
      debugModePrint(e.toString());
    }
  }

  void snapPhoto(String chatId, String friendUid) async {
    try {
      final XFile? image = await imagePicker.pickImage(
          source: ImageSource.camera, imageQuality: 50);

      debugModePrint("Image Selected");
      if (image != null) {
        //Compress file
        File imageFile = await compressFile(File(image.path));
        debugModePrint("Image Compressed");
        String? photoUrl = await uploadImage(imageFile, friendUid);
        debugModePrint("Image Uploaded $photoUrl");
        //do a new chat
        newChat(chatId, friendUid, photoUrl ?? "Image fail to Upload", "Image");
      }
    } catch (e) {
      debugModePrint(e.toString());
    }
  }

  Future<String?> uploadImage(File imageFile, String friendUid) async {
    Reference storageRef = storage.ref(
        "/chats/images/image${friendUid.substring(0, 5)}${appUserController.uid!.substring(0, 5)}${DateTime.now().toString()}");
    try {
      final dataUpload = await storageRef.putFile(imageFile);
      final imageUrl = await storageRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      debugModePrint(e.toString());
      return null;
    }
  }

  Future<File> compressFile(File file) async {
    File compressedFile = await FlutterNativeImage.compressImage(
      file.path,
      quality: 50,
    );
    return compressedFile;
  }

  //=============================Record Audio===================================
  late String recordFilePath;
  void startVoiceRecord() async {
    bool hasPermission = await checkVoicePermission();
    if (hasPermission) {
      recordFilePath = await getFilePath();
      RecordMp3.instance.start(recordFilePath, (type) {});
    } else {
      debugModePrint("No Permission!");
    }
  }

  void stopRecord(String chatId, String friendUid) async {
    bool isStop = RecordMp3.instance.stop();
    audioController.end.value = DateTime.now();
    audioController.calcDuration();
    if (isStop) {
      audioController.isRecording.value = false;
      audioController.isSending.value = true;
      final voiceUrl = await uploadAudio(friendUid);
      newChat(chatId, friendUid, voiceUrl ?? "Voice fail to Upload", "Voice");
    }
  }

  Future<String?> uploadAudio(String friendUid) async {
    Reference storageRef = storage.ref(
        "/chats/audio/audio${friendUid.substring(0, 5)}${appUserController.uid!.substring(0, 5)}${DateTime.now().toString()}");
    try {
      File audioFile = File(recordFilePath);
      final dataUpload = await storageRef.putFile(audioFile);
      final audioUrl = await storageRef.getDownloadURL();
      return audioUrl;
    } catch (e) {
      debugModePrint(e.toString());
      return null;
    }
  }

  Future<bool> checkVoicePermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  int i = 0;
  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath =
        "${storageDirectory.path}/record${DateTime.now().microsecondsSinceEpoch}.acc";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return "$sdPath/test_${i++}.mp3";
  }

  @override
  void onInit() async {
    super.onInit();
    chatC = TextEditingController();
    scrollC = ScrollController();
    imagePicker = ImagePicker();
  }

  @override
  void onClose() {
    super.onClose();
    chatC.dispose();
    scrollC.dispose();
  }
}
