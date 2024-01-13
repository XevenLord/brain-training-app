import 'package:brain_training_app/admin/appointments/ui/view_model/appointment_vmodel.dart';
import 'package:brain_training_app/admin/chat/ui/view_model/chat_vmodel.dart';
import 'package:brain_training_app/admin/games/maths/ui/view_model/math_result_vmodel.dart';
import 'package:brain_training_app/admin/home/domain/services/home_service.dart';
import 'package:brain_training_app/admin/home/ui/view_model/home_vmodel.dart';
import 'package:brain_training_app/admin/insMssg/ui/view_model/ins_mssg_vmodel.dart';
import 'package:brain_training_app/admin/mmse/ui/view_model/mmse_vmodel.dart';
import 'package:brain_training_app/admin/patients/ui/view_model/patient_vmodel.dart';
import 'package:brain_training_app/admin/profile/domain/services/admin_profile_service.dart';
import 'package:brain_training_app/admin/profile/ui/view_model/admin_profile_view_model.dart';
import 'package:brain_training_app/common/domain/service/user_repo.dart';
import 'package:brain_training_app/patient/appointment/ui/view_model/appointment_vmodel.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/service/auth_repo.dart';
import 'package:brain_training_app/patient/chat/domain/services/chat_service.dart';
import 'package:brain_training_app/patient/chat/ui/view_model/chat_vmodel.dart';
import 'package:brain_training_app/patient/game/maths/math_vmodel.dart';
import 'package:brain_training_app/patient/healthCheck/ui/view_model/mental_quiz_vmodel.dart';
import 'package:brain_training_app/patient/home/domain/service/home_service.dart';
import 'package:brain_training_app/patient/home/ui/view_model/feedback_vmodel.dart';
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
  Get.lazyPut(() => ChatService());

  // View Models
  Get.lazyPut(() => HomeViewModel());
  Get.lazyPut(() => AppointmentViewModel());
  Get.lazyPut(() => ChatViewModel(), fenix: true);
  Get.lazyPut(() => AdminChatViewModel(), fenix: true);
  Get.lazyPut(() => ProfileViewModel());
  Get.lazyPut(() => MentalQuizViewModel(), fenix: true);
  Get.lazyPut(() => MathGameViewModel(), fenix: true);
  Get.lazyPut(() => ManagePatientViewModel(), fenix: true);
  Get.lazyPut(() => AdminHomeViewModel());
  Get.lazyPut(() => AdminHomeViewModel());
  Get.lazyPut(() => AdminProfileService());
  Get.lazyPut(() => AdminProfileViewModel());
  Get.lazyPut(() => AdminAppointmentViewModel());
  Get.lazyPut(() => InspirationalMssgViewModel());
  Get.lazyPut(() => MMSEViewModel(), fenix: true);
  Get.lazyPut(() => FeedbackViewModel());

  // *Admin*
  // Admin Service
  Get.lazyPut(() => AdminHomeService());

  // Admin Game Result
  Get.lazyPut(() => MathResultViewModel(), fenix: true);
}
