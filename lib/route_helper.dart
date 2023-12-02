import 'package:brain_training_app/admin/admins/ui/pages/admin_list.dart';
import 'package:brain_training_app/admin/appointments/ui/pages/appointment_main_page.dart';
import 'package:brain_training_app/admin/authentication/ui/pages/sign_up_first_screen.dart';
import 'package:brain_training_app/admin/authentication/ui/pages/sign_up_second_screen.dart';
import 'package:brain_training_app/admin/home/ui/pages/home_page.dart';
import 'package:brain_training_app/patient/appointment/ui/page/appointment_booking_page.dart';
import 'package:brain_training_app/patient/appointment/ui/page/appointment_success_page.dart';
import 'package:brain_training_app/patient/appointment/ui/page/my_appointment_page.dart';
import 'package:brain_training_app/patient/authentification/signIn/ui/page/sign_in_page.dart';
import 'package:brain_training_app/patient/authentification/signUp/ui/page/sign_up_first_page.dart';
import 'package:brain_training_app/patient/authentification/signUp/ui/page/sign_up_second_page.dart';
import 'package:brain_training_app/patient/authentification/signUp/ui/page/sign_up_success_page.dart';
import 'package:brain_training_app/patient/chat/ui/pages/chat.dart';
import 'package:brain_training_app/patient/chat/ui/pages/chat_list.dart';
import 'package:brain_training_app/patient/game/tic_tac_toe/ui/page/ai_game_settings.dart';
import 'package:brain_training_app/patient/home/ui/page/home_page.dart';
import 'package:brain_training_app/patient/profile/ui/page/profile_edit_page.dart';
import 'package:brain_training_app/splash_page.dart';
import 'package:get/get.dart';

import 'patient/appointment/domain/entity/appointment.dart';
import 'patient/appointment/ui/page/appointment_edit_page.dart';

class RouteHelper {
  static const String splash = '/splash';
  static const String signIn = '/signin';
  static const String signUpFirstPage = '/signup-first-page';
  static const String signUpSecondPage = '/signup-second-page';
  static const String signUpDone = '/signup-done';
  static const String forgetPassword = '/forget-password';
  static const String patientHome = '/patient-home';
  static const String ticTacToe = '/tic-tac-toe';
  static const String appointmentBookingPage = '/appointment-booking-page';
  static const String appointmentEditPage = '/appointment-edit-page';
  static const String appointmentSuccessPage = '/appointment-success-page';
  static const String myAppointmentPage = '/my-appointment-page';
  static const String profileEditPage = '/profile-edit-page';
  // *Admin*
  static const String adminSignUpFirstScreen = '/admin-signup-first-screen';
  static const String adminSignUpSecondScreen = '/admin-signup-second-screen';
  static const String adminHome = '/admin-home';
  static const String adminAppointmentPage = '/admin-appointment-page';
  static const String adminAppointmentEditPage = '/admin-appointment-edit-page';
  static const String adminListPage = '/admin-list-page';

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
  static String getTicTacToe() => ticTacToe;
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
  static String getAdminAppointmentPage() => adminAppointmentPage;
  static String getAdminAppointmentEditPage() => adminAppointmentEditPage;
  static String getAdminListPage() => adminListPage;

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
      name: patientHome,
      transition: Transition.fadeIn,
      page: () {
        int? pageIndex = Get.arguments;
        return HomePage(
          pageIndex: pageIndex,
        );
      },
    ),
    GetPage(
      name: ticTacToe,
      transition: Transition.fadeIn,
      page: () => const GameSettings(),
    ),
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
      name: adminAppointmentPage,
      transition: Transition.fadeIn,
      page: () => AppointmentMainPage(),
    ),
    GetPage(
      name: adminListPage,
      transition: Transition.fadeIn,
      page: () => const AdminList(),
    )
  ];
}
