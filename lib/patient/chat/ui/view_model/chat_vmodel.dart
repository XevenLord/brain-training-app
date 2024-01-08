import 'dart:io';

import 'package:brain_training_app/common/domain/entity/message_chat.dart';
import 'package:brain_training_app/patient/chat/domain/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ChatViewModel extends GetxController {
  var currentUser = FirebaseAuth.instance.currentUser?.uid;
  CollectionReference chats = FirebaseFirestore.instance.collection("chats");

  RxMap<String, dynamic> messages = <String, dynamic>{}.obs;
  RxMap<String, dynamic> physioUsers = <String, dynamic>{}.obs;
  final ImagePicker _picker = ImagePicker();

  File? imagefile;
  var _chatImgUrl;

  Future<void> takeImageFromCamera() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    imagefile = File(image!.path);
  }

  Future<void> takeImageFromGallery() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      imagefile = File(image.path);
    } else {
      print('Image capture failed.');
    }
  }

  Future<void> uploadFile() async {
    String fileName = Uuid().v1();
    int status = 1;

    if (imagefile == null) return;
    final storageRef = FirebaseStorage.instance.ref();
    final chatImgRef = storageRef.child(
        '${FirebaseAuth.instance.currentUser?.uid}/photos/${fileName}.jpg');

    chatImgRef.putFile(imagefile!).snapshotEvents.listen((taskSnapshot) async {
      switch (taskSnapshot.state) {
        case TaskState.running:
          break;
        case TaskState.paused:
          break;
        case TaskState.success:
          await chatImgRef
              .getDownloadURL()
              .then((value) => _chatImgUrl = value);
          break;
        case TaskState.error:
          break;
        case TaskState.canceled:
          break;
      }
    });
  }

  Future<bool> sendMessage(MessageChat chat) async {
    // maybe change to string type for this method
    print("got enter here chat vmodel");
    bool res = await ChatService.sendChatMessage(chat);
    return res;
  }

  Future<bool> sendImageMessage(MessageChat chat) async {
    bool res = false;
    await uploadFile();
    if (_chatImgUrl != null) {
      print("got enter here vmodel");
      chat.setMsg(_chatImgUrl);
      res = await ChatService.sendChatMessage(chat);
    }

    return res;
  }

  void refreshChatsForCurrentUser() {
    print("Chat view model " + currentUser.toString());
    var chatDocuments = [];
    chats
        .where('users.$currentUser', isNull: true)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      chatDocuments = snapshot.docs.map((DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Map<String, dynamic> names = data['names'];
        names.remove(currentUser);
        return {'docid': doc.id, 'name': names.values.first};
      }).toList();

      chatDocuments.forEach((doc) {
        FirebaseFirestore.instance
            .collection('chats/${doc['docid']}/messages')
            .orderBy('createdOn', descending: true)
            .limit(1)
            .snapshots()
            .listen((QuerySnapshot snapshot) {
          if (snapshot.docs.isNotEmpty) {
            messages[doc['name']] = {
              'docid': doc['docid'],
              'msg': snapshot.docs.first['msg'],
              'time': snapshot.docs.first['createdOn'],
              'targetName': doc['name'],
              'targetUid': snapshot.docs.first['uid']
            };
          }
        });
      });
    });
  }
}
