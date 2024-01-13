import 'dart:async';

import 'package:brain_training_app/admin/home/domain/services/home_service.dart';
import 'package:brain_training_app/common/domain/service/user_repo.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminHomeViewModel extends GetxController implements GetxService {
  List<AppUser> patientList = [];

  AdminHomeViewModel();
  void signOutUser(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Do you want to log out?', style: AppTextStyle.h3),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('No', style: AppTextStyle.h3),
          ),
          TextButton(
            onPressed: () async {
              await AdminHomeService.signOut();
              showDialog(
                context: context,
                builder: (context) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );
              Timer(
                const Duration(seconds: 2),
                () {
                  Get.offAllNamed(RouteHelper.getSignIn());
                },
              );
            },
            child: Text('Yes', style: AppTextStyle.h3),
          ),
        ],
      ),
    );
  }

  Future<List<AppUser>> fetchAllPatients() async {
    patientList = await UserRepository.fetchAllPatients();
    return patientList;
  }
}
