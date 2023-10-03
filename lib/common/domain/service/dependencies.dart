import 'package:brain_training_app/patient/appointment/ui/view_model/appointment_vmodel.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/service/auth_repo.dart';
import 'package:brain_training_app/patient/chat/domain/service/audiio_controller.dart';
import 'package:brain_training_app/patient/chat/domain/service/chat_home_controller_unilah.dart';
import 'package:brain_training_app/patient/chat/domain/service/chat_room_controller_unilah.dart';
import 'package:brain_training_app/patient/chat/domain/service/chat_search_controller.dart';
import 'package:brain_training_app/patient/chat/domain/service/chat_stream_controller.dart';
import 'package:brain_training_app/patient/chat/domain/service/chat_users_repo.dart';
import 'package:brain_training_app/patient/chat/domain/service/friend_data_repo.dart';
import 'package:brain_training_app/patient/chat/ui/view_model/chat_users_vmodel.dart';
import 'package:brain_training_app/patient/home/domain/service/home_service.dart';
import 'package:brain_training_app/patient/home/ui/view_model/home_vmodel.dart';
import 'package:brain_training_app/patient/profile/ui/view_model/profile_vmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  Get.lazyPut(() => sharedPreferences);

  //Firestore instance
  Get.lazyPut(
    () => FirebaseFirestore.instance,
  );

  // Services
  Get.lazyPut(() => FirebaseAuthRepository());
  Get.lazyPut(() => FriendDataRepo(instance: Get.find()));
  Get.lazyPut(() => ChatUsersRepo(instance: Get.find()));
  Get.lazyPut(() => HomeService());

  // View Models
  Get.lazyPut(() => HomeViewModel());
  Get.lazyPut(() => AppointmentViewModel());
  Get.lazyPut(() => ProfileViewModel());

  Get.lazyPut(() => ChatHomeController(friendDataRepo: Get.find()));
  Get.lazyPut(() => ChatRoomController());
  Get.lazyPut(() => ChatSearchController(friendDataRepo: Get.find()));
  Get.lazyPut(() => ChatStreamController(), fenix: true);
  Get.lazyPut(() => ChatUsersViewModel(usersRepo: Get.find()));
  Get.lazyPut(() => AudioController(), fenix: true);
}
