import 'dart:math';

import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/chat/domain/service/friend_data_repo.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:get/get.dart';

class ChatSearchController extends GetxController implements GetxService {
  late TextEditingController searchC;
  final appUserController = Get.find<AppUser>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late List<CachedFriendData> allFriend;

  var userResults = <CachedFriendData>[].obs;
  // var earlyResult = <AppUser>[].obs;

  final FriendDataRepo friendDataRepo;
  ChatSearchController({required this.friendDataRepo});

  var isLoading = false.obs;

  // Future<void> filterUsers(String keyword) async {
  //   debugModePrint("searching");
  //   var upperCased = keyword.toUpperCase();
  //   // var upperCased = search;
  //   debugModePrint("Capitalised ${upperCased}");
  //   if (keyword.isEmpty) {
  //     userResults.clear();
  //     earlyResult.clear();
  //   } else {
  //     if (keyword.length == 1) {
  //       earlyResult.clear();

  //       CollectionReference users = firestore.collection("users");
  //       final result = await users
  //           .where("name", isGreaterThanOrEqualTo: upperCased.substring(0, 1))
  //           .where("name", isLessThan: '${upperCased.substring(0, 1)}z')
  //           .get();
  //       debugModePrint("Total result: ${result.docs.length}");

  //       if (result.docs.isNotEmpty) {
  //         for (var i = 0; i < result.docs.length; i++) {
  //           var user =
  //               AppUser.fromJson(result.docs[i].data() as Map<String, dynamic>);
  //           if (user.uid != appUserController.uid) {
  //             earlyResult.add(user);
  //             userResults.add(user);
  //           }
  //         }
  //       } else {
  //         debugModePrint("No data found");
  //       }
  //     } else if (keyword.length > 1 && earlyResult.isNotEmpty) {
  //       userResults.clear();
  //       for (var user in earlyResult) {
  //         debugModePrint("UserName ${user.name}");
  //         if (user.name!.toLowerCase().startsWith(keyword.toLowerCase())) {
  //           userResults.add(user);
  //         }
  //       }
  //     }
  //   }
  //   userResults.refresh();
  //   earlyResult.refresh();
  // }

  void filterCachedUsers(String keyword) {
    if (keyword.isEmpty) {
      userResults.value = allFriend;
    } else {
      List<CachedFriendData> result = [];
      isLoading.value = true;

      for (var friend in allFriend) {
        String name = friend.name.toLowerCase();
        // debugModePrint("Name = ${name}");
        // debugModePrint("keyword = ${keyword}");
        int dis = tokenSortPartialRatio(name, keyword);
        // debugModePrint("Lev Dis = $dis");
        if (dis > 85 || name.contains(keyword)) {
          result.add(friend);
        }
      }
      debugModePrint("Total result: ${result}");
      isLoading.value = false;

      if (result.isNotEmpty) {
        userResults.value = result;
      } else {
        userResults.value = [];
        debugModePrint("No data found");
      }
    }
    userResults.refresh();
  }

  List<CachedFriendData> convertToCachedFriendDataList(
      List<dynamic> dynamicList) {
    List<CachedFriendData> cachedFriendDataList = [];

    for (var data in dynamicList) {
      cachedFriendDataList.add(CachedFriendData.fromJson(data));
    }

    return cachedFriendDataList;
  }

  @override
  void onInit() {
    searchC = TextEditingController();
    List<dynamic> data = friendDataRepo.friendDataBox.getValues().toList();
    allFriend = convertToCachedFriendDataList(data);
    userResults.value = allFriend;
    super.onInit();
  }

  @override
  void onClose() {
    searchC.dispose();
    super.onClose();
  }
}
