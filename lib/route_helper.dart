import 'package:brain_training_app/admin/admins/ui/pages/admin_list.dart';
import 'package:brain_training_app/admin/admins/ui/pages/admin_register.dart';
import 'package:brain_training_app/admin/appointments/domain/entity/appointment.dart';
import 'package:brain_training_app/admin/appointments/ui/pages/appointment_edit_page.dart';
import 'package:brain_training_app/admin/appointments/ui/pages/appointment_main_page.dart';
import 'package:brain_training_app/admin/authentication/ui/pages/sign_up_first_screen.dart';
import 'package:brain_training_app/admin/authentication/ui/pages/sign_up_second_screen.dart';
import 'package:brain_training_app/admin/games/common/ui/pages/games_result_categories.dart';
import 'package:brain_training_app/admin/games/maths/ui/math_patient_list.dart';
import 'package:brain_training_app/admin/games/maths/ui/math_score_overview.dart';
import 'package:brain_training_app/admin/home/ui/pages/home_page.dart';
import 'package:brain_training_app/admin/patients/ui/pages/patient_appt.dart';
import 'package:brain_training_app/admin/patients/ui/pages/patient_list.dart';
import 'package:brain_training_app/admin/patients/ui/pages/patient_mental.dart';
import 'package:brain_training_app/admin/patients/ui/pages/patient_overview.dart';
import 'package:brain_training_app/admin/admins/ui/pages/admin_overview.dart';
import 'package:brain_training_app/admin/patients/ui/pages/patient_shout.dart';
import 'package:brain_training_app/admin/profile/ui/pages/admin_edit_profile.dart';
import 'package:brain_training_app/common/domain/entity/math_ans.dart';
import 'package:brain_training_app/patient/appointment/ui/page/appointment_booking_page.dart';
import 'package:brain_training_app/patient/appointment/ui/page/appointment_success_page.dart';
import 'package:brain_training_app/patient/appointment/ui/page/my_appointment_page.dart';
import 'package:brain_training_app/patient/authentification/signIn/ui/page/forget_password_page.dart';
import 'package:brain_training_app/patient/authentification/signIn/ui/page/sign_in_page.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/authentification/signUp/ui/page/sign_up_first_page.dart';
import 'package:brain_training_app/patient/authentification/signUp/ui/page/sign_up_second_page.dart';
import 'package:brain_training_app/patient/authentification/signUp/ui/page/sign_up_success_page.dart';
import 'package:brain_training_app/patient/chat/ui/pages/chat.dart';
import 'package:brain_training_app/patient/chat/ui/pages/chat_list.dart';
import 'package:brain_training_app/patient/game/2048/tzfe_difficulty_page.dart';
import 'package:brain_training_app/patient/game/2048/tzfe_game.dart';
import 'package:brain_training_app/patient/game/2048/tzfe_home.dart';
import 'package:brain_training_app/patient/game/flip_card_memory/flip_card_home.dart';
import 'package:brain_training_app/patient/game/flip_card_memory/memory_game.dart';
import 'package:brain_training_app/patient/game/maths/math_difficulty_page.dart';
import 'package:brain_training_app/patient/game/maths/math_game.dart';
import 'package:brain_training_app/patient/game/tic_tac_toe/ui/page/ai_game_settings.dart';
import 'package:brain_training_app/patient/game/tic_tac_toe/ui/page/ttt_home.dart';
import 'package:brain_training_app/patient/home/ui/page/home_page.dart';
import 'package:brain_training_app/patient/profile/ui/page/profile_edit_page.dart';
import 'package:brain_training_app/splash_page.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:get/get.dart';

import 'patient/appointment/domain/entity/appointment.dart';
import 'patient/appointment/ui/page/appointment_edit_page.dart';
import 'patient/game/maths/math_home.dart';

class RouteHelper {
  static const String splash = '/splash';
  static const String signIn = '/signin';
  static const String signUpFirstPage = '/signup-first-page';
  static const String signUpSecondPage = '/signup-second-page';
  static const String signUpDone = '/signup-done';
  static const String forgetPassword = '/forget-password';
  static const String patientHome = '/patient-home';

  // Game
  static const String mathHome = '/math-home';
  static const String flipCardHome = '/flip-card-home';
  static const String tZFEHome = '/tZFE-home';
  static const String tTTHome = '/tTT-home';

  static const String mathDifficultyPage = '/math-difficulty-page';
  static const String flipCardDifficultyPage = '/flip-card-difficulty-page';
  static const String tZFEDifficultyPage = '/tZFE-difficulty-page';
  static const String tTTDifficultyPage = '/tTT-difficulty-page';

  static const String ticTacToe = '/tic-tac-toe';
  static const String tZFEGame = '/TZFEGame';
  static const String memoryGame = '/memory-game';
  static const String mathGame = '/math-game';

  static const String appointmentBookingPage = '/appointment-booking-page';
  static const String appointmentEditPage = '/appointment-edit-page';
  static const String appointmentSuccessPage = '/appointment-success-page';
  static const String myAppointmentPage = '/my-appointment-page';
  static const String profileEditPage = '/profile-edit-page';
  // *Admin*
  static const String adminSignUpFirstScreen = '/admin-signup-first-screen';
  static const String adminSignUpSecondScreen = '/admin-signup-second-screen';
  static const String adminHome = '/admin-home';
  static const String adminRegister = '/admin-register';

  // *Admin Appointment*
  static const String adminAppointmentPage = '/admin-appointment-page';
  static const String adminAppointmentEditPage = '/admin-appointment-edit-page';

  // *Admin List*
  static const String adminListPage = '/admin-list-page';
  static const String adminOverviewPage = '/admin-overview-page';
  static const String adminProfileEdit = '/admin-profile-edit';

  // *Admin Patient List*
  static const String patientListPage = '/patient-list-page';
  static const String patientOverviewPage = '/patient-overview-page';
  static const String patientApptPage = '/patient-appt-page';
  static const String patientMentalResultPage = '/patient-mental-result-page';
  static const String patientShoutPage = '/patient-shout-page';

  // *Admin Games*
  static const String adminGamePage = '/admin-game-page';

  // *Admin maths*
  static const String mathPatientList = '/math-patient-list';
  static const String mathScoreOverview = '/math-score-overview';

  // chat module
  static const String chatList = '/chat-list';
  static const String chatPage = '/chat';

  static String getSplashScreen() => splash;

  static String getSignIn() => signIn;
  static String getSignUpFirstPage() => signUpFirstPage;
  static String getSignUpSecondPage() => signUpSecondPage;
  static String getSignUpDonePage() => signUpDone;
  static String getForgetPassword() => forgetPassword;
  static String getPatientHome() => patientHome;

  // Game
  static String getMathHome() => mathHome;
  static String getFlipCardHome() => flipCardHome;
  static String getTZFEHome() => tZFEHome;
  static String getTTTHome() => tTTHome;

  static String getMathDifficultyPage() => mathDifficultyPage;
  static String getFlipCardDifficultyPage() => flipCardDifficultyPage;
  static String getTZFEDifficultyPage() => tZFEDifficultyPage;
  static String getTTTDifficultyPage() => tTTDifficultyPage;

  static String getTicTacToe() => ticTacToe;
  static String getTZFEGame() => tZFEGame;
  static String getMemoryGame() => memoryGame;
  static String getMathGame() => mathGame;

  static String getAppointmentBookingPage() => appointmentBookingPage;
  static String getAppointmentEditPage() => appointmentEditPage;
  static String getAppointmentSuccessPage() => appointmentSuccessPage;
  static String getMyAppointmentPage() => myAppointmentPage;
  static String getProfileEditPage() => profileEditPage;

  // chat module
  static String getChatList() => chatList;
  static String getChatPage() => chatPage;

  // *Admin*
  static String getAdminSignUpFirstScreen() => adminSignUpFirstScreen;
  static String getAdminSignUpSecondScreen() => adminSignUpSecondScreen;
  static String getAdminHome() => adminHome;
  static String getAdminRegister() => adminRegister;

  // *Admin Appointment*
  static String getAdminAppointmentPage() => adminAppointmentPage;
  static String getAdminAppointmentEditPage() => adminAppointmentEditPage;

  // *Admin List*
  static String getAdminListPage() => adminListPage;
  static String getAdminOverviewPage() => adminOverviewPage;
  static String getAdminProfileEdit() => adminProfileEdit;

  // *Admin Patient List*
  static String getPatientListPage() => patientListPage;
  static String getPatientOverviewPage() => patientOverviewPage;
  static String getPatientApptPage() => patientApptPage;
  static String getPatientMentalResultPage() => patientMentalResultPage;
  static String getPatientShoutPage() => patientShoutPage;

  // *Admin Games*
  static String getAdminGameCategoriesPage() => adminGamePage;

  // *Admin maths*
  static String getMathPatientList() => mathPatientList;
  static String getMathScoreOverview() => mathScoreOverview;

  static List<GetPage> routes = [
    GetPage(
      name: splash,
      transition: Transition.fadeIn,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: signUpDone,
      transition: Transition.fadeIn,
      page: () => const SignUpDonePage(),
    ),
    GetPage(
      name: signUpFirstPage,
      transition: Transition.fadeIn,
      page: () => const SignUpFirstPage(),
    ),
    GetPage(
      name: signUpSecondPage,
      transition: Transition.fadeIn,
      page: () => const SignUpSecondPage(),
    ),
    GetPage(
      name: signIn,
      transition: Transition.fadeIn,
      page: () => const SignInPage(),
    ),
    GetPage(
      name: forgetPassword,
      transition: Transition.fadeIn,
      page: () => const ForgetPasswordPage(),
    ),
    GetPage(
      name: patientHome,
      transition: Transition.fadeIn,
      page: () {
        int? pageIndex = Get.arguments;
        return HomePage(
          pageIndex: pageIndex,
        );
      },
    ),
    // Game
    GetPage(
      name: mathHome,
      transition: Transition.fadeIn,
      page: () => const MathHome(),
    ),
    GetPage(
      name: flipCardHome,
      transition: Transition.fadeIn,
      page: () => const FlipCardHome(),
    ),
    GetPage(
      name: tZFEHome,
      transition: Transition.fadeIn,
      page: () => const TZFEHome(),
    ),
    GetPage(
      name: tTTHome,
      transition: Transition.fadeIn,
      page: () => const TTTHome(),
    ),

    GetPage(
      name: mathDifficultyPage,
      transition: Transition.fadeIn,
      page: () => MathDifficultyPage(),
    ),
    GetPage(
      name: flipCardDifficultyPage,
      transition: Transition.fadeIn,
      page: () => MemoryGameHomePage(),
    ),
    GetPage(
      name: tZFEDifficultyPage,
      transition: Transition.fadeIn,
      page: () => const TZFEDifficultyPage(),
    ),

    GetPage(
      name: ticTacToe,
      transition: Transition.fadeIn,
      page: () => const GameSettings(),
    ),
    GetPage(
      name: tZFEGame,
      transition: Transition.fadeIn,
      page: () => TZFEGame(),
    ),
    GetPage(
      name: memoryGame,
      transition: Transition.fadeIn,
      page: () => MemoryGameHomePage(),
    ),
    GetPage(
      name: mathGame,
      transition: Transition.fadeIn,
      page: () {
        Level level = Get.arguments;
        print("RH: Level: $level");
        print(level == Level.Easy);
        return MathGame(
          level: level,
        );
      },
    ),

    // Appointment
    GetPage(
      name: appointmentBookingPage,
      transition: Transition.fadeIn,
      page: () {
        return AppointmentBookingPage();
      },
    ),
    GetPage(
      name: appointmentEditPage,
      transition: Transition.fadeIn,
      page: () {
        Appointment appointment = Get.arguments;
        return AppointmentEditPage(
          appointment: appointment,
        );
      },
    ),
    GetPage(
      name: appointmentSuccessPage,
      transition: Transition.fadeIn,
      page: () => AppointmentSuccessPage(),
    ),
    GetPage(
      name: myAppointmentPage,
      transition: Transition.fadeIn,
      page: () => const MyAppointmentPage(),
    ),
    GetPage(
      name: profileEditPage,
      transition: Transition.fadeIn,
      page: () => const ProfileEditPage(),
    ),

    // chat module
    GetPage(
      name: chatList,
      transition: Transition.fadeIn,
      page: () => const ChatList(),
    ),
    GetPage(
      name: chatPage,
      transition: Transition.fadeIn,
      page: () => Chat(),
    ),
    // *Admin*
    GetPage(
      name: adminSignUpFirstScreen,
      transition: Transition.fadeIn,
      page: () => const SignUpFirstScreen(),
    ),
    GetPage(
      name: adminSignUpSecondScreen,
      transition: Transition.fadeIn,
      page: () => const SignUpSecondScreen(),
    ),
    GetPage(
      name: adminHome,
      transition: Transition.fadeIn,
      page: () => AdminHomePage(),
    ),
    GetPage(
      name: adminRegister,
      transition: Transition.fadeIn,
      page: () => const AdminRegisterPage(),
    ),
    // *Admin Appointment*
    GetPage(
      name: adminAppointmentPage,
      transition: Transition.fadeIn,
      page: () => AdminAppointmentMainPage(),
    ),
    GetPage(
      name: adminAppointmentEditPage,
      transition: Transition.fadeIn,
      page: () {
        AdminAppointment appointment = Get.arguments;
        return AdminAppointmentEditPage(
          appointment: appointment,
        );
      },
    ),
    // *Admin List*
    GetPage(
      name: adminListPage,
      transition: Transition.fadeIn,
      page: () => const AdminList(),
    ),
    GetPage(
      name: adminOverviewPage,
      transition: Transition.fadeIn,
      page: () {
        AppUser admin = Get.arguments;
        return AdminOverview(admin: admin);
      },
    ),
    GetPage(
      name: adminProfileEdit,
      transition: Transition.fadeIn,
      page: () {
        AppUser appUser = Get.arguments;
        return AdminProfileEdit(appUser: appUser);
      },
    ),

    // *Admin Patient List*
    GetPage(
      name: patientListPage,
      transition: Transition.fadeIn,
      page: () => const PatientList(),
    ),
    GetPage(
      name: patientOverviewPage,
      transition: Transition.fadeIn,
      page: () {
        AppUser patient = Get.arguments;
        return PatientOverview(patient: patient);
      },
    ),
    GetPage(
      name: patientApptPage,
      transition: Transition.fadeIn,
      page: () {
        AppUser patient = Get.arguments;
        return PatientAppointmentPage(patient: patient);
      },
    ),
    GetPage(
      name: patientMentalResultPage,
      transition: Transition.fadeIn,
      page: () {
        AppUser patient = Get.arguments;
        return PatientMentalResult(patient: patient);
      },
    ),
    GetPage(
      name: patientShoutPage,
      transition: Transition.fadeIn,
      page: () {
        AppUser patient = Get.arguments;
        return PatientShoutPage(patient: patient);
      },
    ),
    // *Admin Games*
    GetPage(
      name: adminGamePage,
      transition: Transition.fadeIn,
      page: () => const GamesResultCategories(),
    ),
    // *Admin maths*
    GetPage(
      name: mathPatientList,
      transition: Transition.fadeIn,
      page: () => const MathPatientList(),
    ),
    GetPage(
      name: mathScoreOverview,
      transition: Transition.fadeIn,
      page: () {
        AppUser patient = Get.arguments[0];
        List<MathAnswer> mathAns = Get.arguments[1];
        return MathScoreOverview(
          patient: patient,
          mathAns: mathAns,
        );
      },
    ),
  ];
}
