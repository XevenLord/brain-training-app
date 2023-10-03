import 'dart:async';

import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/service/auth_repo.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  bool resourceLoaded = false;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
    // Future.delayed(const Duration(seconds: 2), () {
    //   loaded();
    // });
    debugModePrint("splash page: running authStateChanges");

    Future.delayed(const Duration(seconds: 2), () {
      loaded();
    });
  }

  Future<void> loaded() async {
    debugModePrint("splash page: enter loaded");
    resourceLoaded = await AppConstant.loadResources();
    if (resourceLoaded && FirebaseAuth.instance.currentUser != null) {
      Get.offAllNamed(
        RouteHelper.getPatientHome(),
      );
    } else {
      Get.offNamed(RouteHelper.getSignIn());
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: animation,
            child: Center(
                child: Image.asset(AppConstant.NEUROFIT_LOGO, width: 300.w)),
          ),
        ],
      ),
    );
  }
}
