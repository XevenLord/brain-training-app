import 'package:brain_training_app/patient/appointment/ui/page/appointment_booking_page.dart';
import 'package:brain_training_app/patient/appointment/ui/page/appointment_success_page.dart';
import 'package:brain_training_app/patient/appointment/ui/page/my_appointment_page.dart';
import 'package:brain_training_app/patient/authentification/signIn/ui/page/sign_in_page.dart';
import 'package:brain_training_app/patient/authentification/signUp/ui/page/sign_up_first_page.dart';
import 'package:brain_training_app/patient/authentification/signUp/ui/page/sign_up_second_page.dart';
import 'package:brain_training_app/patient/authentification/signUp/ui/page/sign_up_success_page.dart';
import 'package:brain_training_app/patient/chat/ui/page/chat_home_page_unilah.dart';
import 'package:brain_training_app/patient/chat/ui/page/chat_prep_send.dart';
import 'package:brain_training_app/patient/chat/ui/page/chat_room_page.dart';
import 'package:brain_training_app/patient/chat/ui/page/chat_search_page.dart';
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

  // chat module
  static const String chatHomePage = "/chat-home-page";
  static const String chatRoomPage = "/chat-room-page";
  static const String chatSearchPage = "/chat-search-page";
  static const String chatPrepSendPage = "/chat-prep-send-page";

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
  static String getChatHomePage() => chatHomePage;
  static String getChatRoomPage() => chatRoomPage;
  static String getChatSearchPage() => chatSearchPage;
  static String getChatPrepSendPage() => chatPrepSendPage;

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
    //Chat
    GetPage(
      name: chatHomePage,
      page: () => ChatHomePage(),
    ),
    GetPage(
      name: chatRoomPage,
      page: () => const ChatRoomPage(),
    ),
    GetPage(
      name: chatSearchPage,
      page: () => ChatSearchPage(),
    ),
    GetPage(
      name: chatPrepSendPage,
      page: () => ChatPrepSendPage(),
    ),
  ];
}
