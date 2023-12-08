import 'package:brain_training_app/admin/appointments/ui/view_model/appointment_vmodel.dart';
import 'package:brain_training_app/admin/home/domain/services/home_service.dart';
import 'package:brain_training_app/admin/home/ui/view_model/home_vmodel.dart';
import 'package:brain_training_app/admin/profile/domain/services/admin_profile_service.dart';
import 'package:brain_training_app/admin/profile/ui/view_model/admin_profile_view_model.dart';
import 'package:brain_training_app/common/domain/service/user_repo.dart';
import 'package:brain_training_app/patient/appointment/ui/view_model/appointment_vmodel.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/service/auth_repo.dart';
import 'package:brain_training_app/patient/chat/ui/view_model/chat_vmodel.dart';
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
  Get.lazyPut(() => HomeService());
  Get.lazyPut(() => UserRepository());

  // View Models
  Get.lazyPut(() => HomeViewModel());
  Get.lazyPut(() => AppointmentViewModel());
  Get.lazyPut(() => ChatViewModel(), fenix: true);
  Get.lazyPut(() => ProfileViewModel());

  // *Admin*
  // Admin Service
  Get.lazyPut(() => AdminHomeService());
  Get.lazyPut(() => AdminHomeViewModel());
  Get.lazyPut(() => AdminProfileService());
  Get.lazyPut(() => AdminProfileViewModel());
  Get.lazyPut(() => AdminAppointmentViewModel());
}
