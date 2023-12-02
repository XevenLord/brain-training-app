import 'dart:async';

import 'package:brain_training_app/patient/home/domain/service/home_service.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeViewModel extends GetxController implements GetxService {
  HomeViewModel();

  void signOutUser(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Do you want to log out?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              print("you choose no");
              Get.back();
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () async {
              await HomeService.signOut();
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
                () => Get.offNamed(RouteHelper.getSignIn()),
              );
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }
}
