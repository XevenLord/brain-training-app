import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get_storage/get_storage.dart';

class FriendDataRepo extends GetxService {
  final FirebaseFirestore instance;
  FriendDataRepo({required this.instance});

  // bool _isFriendLagged = false;
  // bool get isFriendLagged => _isFriendLagged;

  final friendDataBox = GetStorage('friendData');

  Future<AppUser?> getFriendsData(String uid) async {
    try {
      final friendsQuery = await instance.collection("users").doc(uid).get();

      if (friendsQuery.exists) {
        debugModePrint("Friends exists");
        return AppUser.fromJson(friendsQuery.data()!);
      }
    } catch (e) {
      debugModePrint("Failed with error $e");
    }
    return null;
  }

  Future<bool> writeCachedFriendData(String uid, String chatId) async {
    AppUser? friendData = await getFriendsData(uid);
    debugModePrint("Store successfully in cache.");
    if (friendData != null) {
      friendDataBox.write(friendData.uid!, {
        "uid": uid,
        "name": friendData.name!,
        "profilepic": friendData.profilePic ?? "",
        "chatId": chatId
      });
      debugModePrint("Store successfully in cache. ${friendData.uid}");
      return true;
    } else {
      debugModePrint("Store fail in cache.");
      return false;
    }
  }

  CachedFriendData? readCachedFriendData(String uid) {
    debugModePrint("Reading Cached Current Uid: $uid");
    try {
      final friendData = friendDataBox.read(uid);
      CachedFriendData datas = CachedFriendData.fromJson(friendData);
      return datas;
    } catch (e) {
      debugModePrint("Read cache fail. $e");
      return null;
    }
  }
}

class CachedFriendData {
  CachedFriendData({
    required this.uid,
    required this.name,
    required this.profilePic,
    required this.chatId,
  });

  String uid;
  String name;
  String profilePic;
  String chatId;

  factory CachedFriendData.fromJson(Map<String, dynamic> json) =>
      CachedFriendData(
        uid: json["uid"],
        name: json["name"],
        profilePic: json["profilePic"] ?? "",
        chatId: json["chatId"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "profilePic": profilePic,
        "chatId": chatId,
      };

  @override
  String toString() {
    return "Name $name, profilePic $profilePic, chatId $chatId";
  }
}
