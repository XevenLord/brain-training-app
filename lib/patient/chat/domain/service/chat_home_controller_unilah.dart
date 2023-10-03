import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/chat/domain/service/friend_data_repo.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatHomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final appUserController = Get.find<AppUser>();

  // late List<AppUser> _friendList = <AppUser>[].obs;
  // List<AppUser> get friendList => _friendList;

  final FriendDataRepo friendDataRepo;
  ChatHomeController({required this.friendDataRepo});

  //=============Use this code to initiate a new connection=====================
  // chatHomeC.checkConnection(friend.uid!, friend.name!);

  void checkConnection(
      String friendUid, String friendName, bool toChatScreen) async {
    CollectionReference users = firestore.collection("users");
    CollectionReference chats = firestore.collection("chats");
    String date = DateTime.now().toIso8601String();

    //pull down the list of email before from Chat Collection
    final docChats = await chats.where("connections", whereIn: {
      [appUserController.uid, friendUid],
      [friendUid, appUserController.uid]
    }).get();
    var chatId;

    if (docChats.docs.isEmpty) {
      debugPrint("Doesn't exists in chat collection!");

      //Add New Collection in chat and user collection but not friend collection
      chatId = await addNewConnection(friendUid, date);
    } else {
      chatId = docChats.docs[0].id;
      debugPrint("Exists in chat collection! Id is $chatId");

      //Update user collection with last time access!
      await users
          .doc(appUserController.uid)
          .collection("userChat")
          .doc(docChats.docs[0].id)
          .update({"lastTime": date});
    }

    //Route to the chat room
    // debugPrint("Routing to Chat = $chatId");
    if (toChatScreen) {
      Get.toNamed(RouteHelper.getChatRoomPage(), arguments: {
        "chatId": chatId,
        "friendUid": friendUid,
        "friendName": friendName
      });
    }
  }

  Future<String> addNewConnection(String friendUid, String date) async {
    CollectionReference users = firestore.collection("users");
    CollectionReference chats = firestore.collection("chats");

    //Add to Chat Collection
    final newChatDoc = await chats.add({
      "connections": [appUserController.uid, friendUid],
    });
    //chat Collection in Chats Collection
    await chats.doc(newChatDoc.id).collection("chats");

    //Add to User Collection
    final currentUser = Get.find<AppUser>();
    await users
        .doc(appUserController.uid)
        .collection("userChat")
        .doc(newChatDoc.id)
        .set({
      "connection": friendUid,
      "chatId": newChatDoc.id,
      "lastTime": date,
      "lastContent": "",
      "lastSender": currentUser.uid ?? "",
      "totalUnread": 0
    });

    //Add to Cache
    friendDataRepo.writeCachedFriendData(friendUid, newChatDoc.id);

    return newChatDoc.id;
  }

  void routeToChatRoom(String chatId, String friendUid, String friendName) {
    updatetotalUnread(chatId);
    updateChattingWith(friendUid);
    Get.toNamed(RouteHelper.getChatRoomPage(), arguments: {
      "chatId": chatId,
      "friendUid": friendUid,
      "friendName": friendName
    });
  }

  void updateChattingWith(String friendUid) async {
    CollectionReference users = firestore.collection("users");
    debugPrint("Current Friend Uid is $friendUid");
    try {
      await users
          .doc(appUserController.uid)
          .update({"chattingWith": friendUid});
    } catch (e) {
      debugPrint("Update chattingWith failed: $e");
    }
  }

  void updatetotalUnread(String chatId) async {
    CollectionReference users = firestore.collection("users");
    CollectionReference chats = firestore.collection("chats");

    //Update isRead to true
    final updateStatusChat = await chats
        .doc(chatId)
        .collection("chat")
        .where("isRead", isEqualTo: false)
        .where("receiver", isEqualTo: appUserController.uid)
        .get();

    //Loop through each chat and update isRead to true
    updateStatusChat.docs.forEach((singleChat) async {
      await chats
          .doc(chatId)
          .collection("chat")
          .doc(singleChat.id)
          .update({"isRead": true});
    });

    //Reset the totalunread to 0
    await users
        .doc(appUserController.uid)
        .collection("userChat")
        .doc(chatId)
        .update({"totalUnread": 0});
  }

  bool checkOnline(signInTime) {
    if (signInTime != null) {
      DateTime? friendLastOnlineTime = DateTime.tryParse(signInTime!);
      Duration diff = DateTime.now().difference(friendLastOnlineTime!);
      // debugPrint("Difference in minutes, ${diff.inMinutes.toString()}");
      if (diff.inMinutes.toInt() < 10) {
        return true;
      }
    }
    return false;
  }

  //Stream People and chats for real time update
  Stream<QuerySnapshot<Map<String, dynamic>>> chatsStream(String uid) {
    return firestore
        .collection("users")
        .doc(uid)
        .collection("userChat")
        .orderBy("lastTime", descending: true)
        .snapshots();
  }

  //Stream for Profile pic
  Stream<DocumentSnapshot<Map<String, dynamic>>> friendsStream(String uid) {
    return firestore.collection("users").doc(uid).snapshots();
  }

  CachedFriendData? readFriendData(uid) {
    return friendDataRepo.readCachedFriendData(uid);
  }

  Future<bool> writeFriendData(String friendUid, String chatId) async {
    return await friendDataRepo.writeCachedFriendData(friendUid, chatId);
  }
}
