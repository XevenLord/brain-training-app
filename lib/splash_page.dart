import 'dart:async';

import 'package:brain_training_app/admin/appointments/domain/entity/appointment.dart';
import 'package:brain_training_app/admin/appointments/ui/view_model/appointment_vmodel.dart';
import 'package:brain_training_app/common/domain/service/notification_api.dart';
import 'package:brain_training_app/common/domain/service/user_repo.dart';
import 'package:brain_training_app/patient/appointment/ui/view_model/appointment_vmodel.dart';
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
  late AppointmentViewModel appointmentViewModel;
  late AdminAppointmentViewModel adminAppointmentViewModel;
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
    NotificationAPI.init(initScheduled: true);
    listenNotifications();
    if (resourceLoaded && FirebaseAuth.instance.currentUser != null) {
      appointmentViewModel = Get.find<AppointmentViewModel>();
      adminAppointmentViewModel = Get.find<AdminAppointmentViewModel>();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        getPhysiotherapistList();
        if (Get.find<AppUser>().role == "admin") {
          UserRepository.fetchAllPatients();
        }
      });
      Get.offAllNamed(Get.find<AppUser>().role == "admin"
          ? RouteHelper.getAdminHome()
          : RouteHelper.getPatientHome());
    } else {
      Get.offNamed(RouteHelper.getSignIn());
    }
  }

  void listenNotifications() =>
      NotificationAPI.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) {
    Get.toNamed(RouteHelper.getPatientHome());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void getPhysiotherapistList() async {
    await appointmentViewModel.getPhysiotherapistList();
    await adminAppointmentViewModel.getPhysiotherapistList();
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
