import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/chat/domain/service/chat_home_controller_unilah.dart';
import 'package:brain_training_app/patient/chat/domain/service/chat_search_controller.dart';
import 'package:brain_training_app/patient/chat/domain/service/friend_data_repo.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChatSearchPage extends GetView<ChatSearchController> {
  ChatSearchPage({super.key});
  final appUserController = Get.find<AppUser>();
  final chatHomeC = Get.find<ChatHomeController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(children: [
        pageHeader(),
        SizedBox(
          height: 30.h,
        ),
        Obx(
          () => controller.userResults.isEmpty
              ? Center(
                  child: Container(
                      width: Get.width * 0.7,
                      // height: Get.height * 0.7,
                      alignment: Alignment.center,
                      // child: Lottie.asset(AppConstant.EMPTYLOTTIE)),
                      child: const Text("No Data Found...")),
                )
              : controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : SingleChildScrollView(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.userResults.length,
                        itemBuilder: (context, i) =>
                            chatBoxInSearch(controller.userResults[i]),
                      ),
                    ),
        )
      ]),
    ));
  }

  Widget pageHeader() {
    // Page header
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 30.w),
      decoration: const BoxDecoration(
        color: AppColors.brandBlue,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Title
          Container(
            padding: EdgeInsets.only(right: 20.w),
            child: InkWell(
              onTap: () {
                //Back to previous page
                Get.back();
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24.w,
              ),
            ),
          ),
          Expanded(
              child: TextField(
            style: AppTextStyle.c1,
            controller: controller.searchC,
            onChanged: (value) =>
                // controller.filterUsers(value),
                controller.filterCachedUsers(value),
            decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide.none),
                hintText: 'Enter a search term',
                hintStyle: AppTextStyle.c1),
          )),
        ],
      ),
    );
  }

  Widget chatBoxInSearch(CachedFriendData friendData) {
    return InkWell(
      onTap: () {
        // chatHomeC.checkConnection(friendData.uid, friendData.name);
        chatHomeC.routeToChatRoom(friendData.chatId, friendData.uid, friendData.name);
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          width: Get.width,
          margin: EdgeInsets.only(bottom: 8.h),
          height: 80.h,
          child: Row(
            children: [
              Container(
                // color: Colors.amber,
                width: 80.h,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    image: DecorationImage(
                      image: friendData.profilePic == "" || friendData.profilePic == null
                          ? const AssetImage(AppConstant.NO_PROFILE_PIC)
                          : Image.network(friendData.profilePic) as ImageProvider,
                      // image: AssetImage(AppConstant.NO_PROFILE_PIC),
                      fit: BoxFit.cover,
                    )),
              ),
              SizedBox(width: 16.h),
              chatText(friendData.name),
            ],
          )),
    );
  }

  Widget chatText(content) {
    return Text(
      content,
      maxLines: 1,
      style: AppTextStyle.c1.merge(const TextStyle(
        color: AppColors.black,
        overflow: TextOverflow.ellipsis,
      )),
    );
  }
}
