import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ChatViewModel extends GetxController {
  var currentUser = FirebaseAuth.instance.currentUser?.uid;
  CollectionReference chats = FirebaseFirestore.instance.collection("chats");

  RxMap<String, dynamic> messages = <String, dynamic>{}.obs;

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

        return {'docid': doc.id, 'name': names.values.first};
      }).toList();

      chatDocuments.forEach((doc) {
        FirebaseFirestore.instance
            .collection('chats/${doc['docid']}/messages')
            .orderBy('createdOn', descending: true)
            .limit(1)
            .snapshots()
            .listen((QuerySnapshot snapshot) {
              if(snapshot.docs.isNotEmpty) {
                messages[doc['names']] = {
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