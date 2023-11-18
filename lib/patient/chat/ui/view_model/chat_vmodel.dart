import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChatViewModel extends GetxController {
  var currentUser = FirebaseAuth.instance.currentUser?.uid;
  CollectionReference chats = FirebaseFirestore.instance.collection("chats");

  RxMap<String, dynamic> messages = <String, dynamic>{}.obs;
  RxMap<String, dynamic> physioUsers = <String, dynamic>{}.obs;
  final ImagePicker _picker = ImagePicker();

  File? imagefile;
  var _profilePicUrl;

  // initUsersListener() {
  //   FirebaseFirestore.instance
  //       .collection("physiotherapists")
  //       .snapshots()
  //       .listen((QuerySnapshot snapshot) {
  //     snapshot.docs.forEach((doc) {
  //       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //       physioUsers[data['id']] = {
  //         'name': data['name'],
  //         'imgUrl': data['imgUrl']
  //       };
  //     });
  //   });
  //   print("CHAT VIEW MODEL: trigger initUsersListener");
  // }

  void takeImageFromCamera() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    imagefile = File(image!.path);
  }

  void _uploadFile() {
    if (imagefile == null) return;
    final storageRef = FirebaseStorage.instance.ref();
    final profileImagesRef = storageRef
        .child('${FirebaseAuth.instance.currentUser?.uid}/photos/profile.jpg');

    profileImagesRef.putFile(imagefile!).snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          break;
        case TaskState.paused:
          break;
        case TaskState.success:
          profileImagesRef
              .getDownloadURL()
              .then((value) => _profilePicUrl = value);
          break;
        case TaskState.error:
          break;
        case TaskState.canceled:
          break;
      }
    });
  }

  void refreshChatsForCurrentUser() {
    var chatDocuments = [];
    chats
        .where('users.$currentUser', isNull: true)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      chatDocuments = snapshot.docs.map((DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Map<String, dynamic> names = data['names'];
        names.remove(currentUser);
        print("REFRESH CHAT names keys:" + names.keys.first);
        print("REFRESH CHAT names map:" + names.values.first);


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
