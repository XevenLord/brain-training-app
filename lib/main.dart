import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/authentification/signUp/ui/view_model/sign_up_controller.dart';
import 'package:brain_training_app/patient/game/2048/models/board_adapter.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:camera/camera.dart';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import 'package:brain_training_app/common/domain/service/dependencies.dart'
    as dep;
import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_options.dart';
import 'patient/authentification/signUp/domain/service/auth_repo.dart';

late List<CameraDescription> camerasAvailable;
late FlutterSecureStorage secureStorage;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  secureStorage = FlutterSecureStorage();
  await dep.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  Hive.registerAdapter(BoardAdapter());

  FirebaseAuthRepository.subscribeIDTokenListening();

  Get.put(AppUser());
  Get.put(SignUpController());

  camerasAvailable = await availableCameras();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(450, 974.4),
        builder: (context, child) {
          return ProviderScope(
            child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Neurofit',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              initialRoute: RouteHelper.getSplashScreen(),
              getPages: RouteHelper.routes,
            ),
          );
        });
  }
}
