import 'package:brain_training_app/patient/home/ui/page/home_page.dart';
import 'package:brain_training_app/splash_page.dart';
import 'package:get/get_navigation/get_navigation.dart';

class RouteHelper {
  static const String splash = '/splash';
  static const String patientHome = '/patient-home';

  static String getSplashScreen() => splash;
  static String getPatientHome() => patientHome;

  static List<GetPage> routes = [
    GetPage(
      name: splash,
      transition: Transition.fadeIn,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: patientHome,
      transition: Transition.fadeIn,
      page: () => const HomePage(),
    ),
  ];
}
