import 'package:brain_training_app/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() {
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
