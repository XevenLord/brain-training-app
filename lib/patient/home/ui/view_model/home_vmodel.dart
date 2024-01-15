import 'dart:async';
import 'dart:math';

import 'package:brain_training_app/admin/patients/domain/entity/inspirational_mssg.dart';
import 'package:brain_training_app/patient/home/domain/service/home_service.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeViewModel extends GetxController implements GetxService {
  List<InspirationalMessage> inspirationalMessages = [];
  List<InspirationalMessage> generalInspirationalMessages = [];
  HomeViewModel();

  void signOutUser(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Do you want to log out?', style: AppTextStyle.h3),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              print("you choose no");
              Get.back();
            },
            child: Text('No', style: AppTextStyle.h3),
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

  Future<void> fetchInspirationalMessages() async {
    inspirationalMessages = await HomeService.fetchInspirationalMessages();
    print(inspirationalMessages);
    update();
  }

  Future<void> fetchGeneralInspirationalMessages() async {
    generalInspirationalMessages =
        await HomeService.fetchGeneralInspirationalMessages();
    print(generalInspirationalMessages);
    update();
  }

  void showPopUpInspirationalMessageDialog(DateTime? date) async {
    // if (date != null && DateTime.now().difference(date).inHours > 0) {
    //   return;
    // }
    date = date ?? DateTime.now();
    Random random = Random();
    if (inspirationalMessages.isNotEmpty) {
      List<InspirationalMessage> filteredInspirationalMessages =
          inspirationalMessages
              .where((element) =>
                  element.readAt == null || element.readAt!.isBefore(date!))
              .toList();
      InspirationalMessage insMssg = filteredInspirationalMessages[
          random.nextInt(filteredInspirationalMessages.length)];

      String sender = insMssg.sender ?? "Your Loved One";
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.lightYellow,
          title: Text('From $sender : ', style: AppTextStyle.h2),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              insMssg.imgUrl != null && insMssg.imgUrl!.isNotEmpty
                  ? CircleAvatar(
                      radius: 120.r,
                      backgroundColor: AppColors.lightYellow,
                      backgroundImage: NetworkImage(insMssg.imgUrl!),
                    )
                  : Image(
                      image: const AssetImage(AppConstant.HUG_IMG),
                      height: 150.w,
                    ),
              SizedBox(height: 10.w),
              Text(insMssg.message!, style: AppTextStyle.h3),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await HomeService.updateReadAtStatus(insMssg.id!);
                Get.back();
              },
              child: Text('Received',
                  style:
                      AppTextStyle.h3.merge(AppTextStyle.brandYellowTextStyle)),
            ),
          ],
        ),
      );
    } else {
      print(generalInspirationalMessages.length);
      InspirationalMessage insMssg = generalInspirationalMessages[
          random.nextInt(generalInspirationalMessages.length)];
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.lightYellow,
          title: Text('From NeuroFit : ', style: AppTextStyle.h2),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Image(
                image: AssetImage(AppConstant.HUG_IMG),
              ),
              Text(insMssg.message!, style: AppTextStyle.h3),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Received',
                  style:
                      AppTextStyle.h3.merge(AppTextStyle.brandYellowTextStyle)),
            ),
          ],
        ),
      );
    }
  }

  Future<void> updateLastInspired() async {
    await HomeService.updateLastInspired();
  }
}
