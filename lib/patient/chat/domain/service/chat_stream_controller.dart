import 'dart:async';

import 'package:brain_training_app/utils/app_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ChatStreamController extends GetxService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late StreamController<QuerySnapshot<Map<String, dynamic>>> streamC;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? chatsStream;

  String? _chatId;

  void streamChats() {
    if (_chatId != null) {
      CollectionReference chats = firestore.collection("chats");
      chatsStream = chats
          .doc(_chatId)
          .collection("chat")
          .limit(20)
          .orderBy("time", descending: false)
          .snapshots()
          .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
        streamC.add(snapshot);
      });
    }
  }

  void setChatId(String chatId) {
    _chatId = chatId;
    streamChats();
  }

  void resumeStream() {
    streamC.onResume;
    chatsStream?.resume();
    debugModePrint('Chat Stream on Resume');
  }

  void pauseStream() {
    streamC.onPause;
    chatsStream?.cancel();
    debugModePrint('Chat Stream on Pause');
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> get stream => streamC.stream;

  @override
  void onInit() {
    super.onInit();
    streamC = StreamController<QuerySnapshot<Map<String, dynamic>>>();
  }

  @override
  void onClose() {
    super.onClose();
    debugModePrint("Closing Stream");
    streamC.close();
    chatsStream?.cancel();
  }
}
