import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ChatUsersRepo extends GetxService {
  final FirebaseFirestore instance;

  ChatUsersRepo({required this.instance});

  bool _isUsersLagged = false;
  bool get isUsersLagged => _isUsersLagged;

  Future<List<AppUser>> getUsersList({bool fromCache = true}) async {
    List<AppUser> usersList = [];
    late final QuerySnapshot<Map<String, dynamic>> usersListQuery;
    try {
      usersListQuery = await instance
          .collection("users")
          .limit(40)
          .get(GetOptions(source: fromCache ? Source.cache : Source.server));
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        debugModePrint("Failed with error ${e.code}: ${e.message}");
        //Catch network error
        var connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          _isUsersLagged = true;
          usersListQuery = await instance
              .collection("users")
              .get(const GetOptions(source: Source.cache));
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    for (var userData in usersListQuery.docs) {
      if (userData.exists) {
        dynamic data = userData.data();
        data.addAll({"uid": userData.id});
        usersList.add(AppUser.fromJson(data));
      } else {
        if (kDebugMode) {
          debugModePrint(
              "Failed to add user to userList in getUserList method");
        }
      }
    }
    return usersList;
  }
}
