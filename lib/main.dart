import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/authentification/signUp/ui/view_model/sign_up_controller.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:brain_training_app/common/domain/service/dependencies.dart'
    as dep;

import 'firebase_options.dart';
import 'patient/authentification/signUp/domain/service/auth_repo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dep.init();
  print("Hellow");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("World");

  FirebaseAuthRepository.subscribeIDTokenListening();
  print("World 2");

  Get.put(AppUser());
  Get.put(SignUpController());
  print("World 3");

  runApp(const MyApp());
  print("World 4");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(450, 974.4),
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Neurofit',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            initialRoute: RouteHelper.getSplashScreen(),
            getPages: RouteHelper.routes,
          );
        });
  }
}
