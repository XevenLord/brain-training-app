import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/chat/domain/service/chat_users_repo.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatUsersViewModel extends GetxController implements GetxService {
  // final SharedPreferences sharedPreferences;
  final ChatUsersRepo usersRepo;

  ChatUsersViewModel({required this.usersRepo});

  late var _usersList = <AppUser>[].obs;
  List<AppUser> get usersList => _usersList;

  @override
  void onInit() {
    super.onInit();
    debugModePrint("Initialised data");
  }

  Future<bool> getUsers() async {
    // bool loaded = false;
    try {
      List<AppUser> tempUserList = [];
      _usersList = <AppUser>[].obs;
      tempUserList = await usersRepo.getUsersList(fromCache: false);
      addUsersinList(tempUserList);
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugModePrint(e.toString());
      }
      return false;
    }
  }

  // bool updatedVersionUsersList(List<AppUser> tempUsersList) {
  //   if (tempUsersList.isNotEmpty) {
  //     addUsersinList(tempUsersList);

  //     //Check network issue
  //     if (!usersRepo.isUsersLagged) {
  //       //If network no issue
  //       //Store the updated version of user list
  //       sharedPreferences.setInt(
  //           AppConstant.USERS_VERSION, AppConstant.version.users);
  //     }

  //     return true;
  //   } else {
  //     debugModePrint("User list is empty");
  //     return false;
  //   }
  // }

  void addUsersinList(List<AppUser> usersList) {
    for (AppUser users in usersList) {
      _usersList.add(users);
    }
  }
}
