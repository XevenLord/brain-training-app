import 'dart:async';
import 'dart:math';

import 'package:brain_training_app/admin/patients/domain/entity/inspirational_mssg.dart';
import 'package:brain_training_app/patient/home/domain/service/home_service.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeViewModel extends GetxController implements GetxService {
  bool isInsMssgShown = false;
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
    if (isInsMssgShown) {
      return;
    }

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
          title: RichText(
            text: TextSpan(
              style:
                  AppTextStyle.h2.merge(const TextStyle(color: Colors.black)),
              children: [
                const TextSpan(
                  text: "From ",
                ),
                TextSpan(
                  text: "$sender : ",
                  style: AppTextStyle.h2.merge(const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic)),
                ),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              insMssg.imgUrl != null && insMssg.imgUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: insMssg.imgUrl!,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(), // Loading indicator
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error), // Error widget
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        radius: 120.r,
                        backgroundColor: AppColors.lightYellow,
                        backgroundImage: imageProvider,
                      ),
                    )
                  : const Image(
                      image: AssetImage(AppConstant.HUG_IMG),
                    ),
              SizedBox(height: 10.w),
              Text(
                '"${insMssg.message!}"',
                style: AppTextStyle.h3.merge(const TextStyle(
                    fontWeight: FontWeight.w800, fontStyle: FontStyle.italic)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                isInsMssgShown = true;
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
          title: RichText(
            text: TextSpan(
              style:
                  AppTextStyle.h2.merge(const TextStyle(color: Colors.black)),
              children: [
                const TextSpan(
                  text: "From ",
                ),
                TextSpan(
                  text: "NeuroFit : ",
                  style: AppTextStyle.h2.merge(const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic)),
                ),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Image(
                image: AssetImage(AppConstant.HUG_IMG),
              ),
              Text(
                '"${insMssg.message!}"',
                style: AppTextStyle.h3.merge(const TextStyle(
                    fontWeight: FontWeight.w800, fontStyle: FontStyle.italic)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                isInsMssgShown = true;
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
