import 'package:brain_training_app/common/ui/widget/screen.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/chat/domain/service/chat_home_controller_unilah.dart';
import 'package:brain_training_app/patient/chat/ui/view_model/chat_users_vmodel.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

class ChatHomePage extends GetView<ChatHomeController> {
  ChatHomePage({super.key});
  Future<void> _loadResource() async {
    AppConstant.loadResources();
  }

  final usersController = Get.find<ChatUsersViewModel>();
  final appUserController = Get.find<AppUser>();
  @override
  Widget build(BuildContext context) {
    // debugModePrint("Initialising Chat Home");
    return RefreshIndicator(
      onRefresh: _loadResource,
      child: Screen(
        appBarTitle: "Chats",
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: controller.chatsStream(appUserController.uid!),
            builder: (context, snapshot1) {
              //initialising stream to fetch the chat from user itself
              if (snapshot1.connectionState == ConnectionState.active) {
                debugModePrint("Length of chat ${snapshot1.data?.docs.length}");

                //Convert all data from firebase to UserChat model while removing blocked user
                List<UserChat?> allChats = [];
                if (snapshot1.data?.docs != null) {
                  allChats = snapshot1.data!.docs
                      .map((doc) {
                        Map<String, dynamic> data = doc.data();
                        return UserChat.fromJson(data);
                      })
                      .where((element) => element != null)
                      .toList();
                }
                //The user have chatted with someone else before
                if (allChats.isNotEmpty) {
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: allChats.length,
                      itemBuilder: (context, i) {
                        //initialising stream to fetch the data associate with his friends
                        return StreamBuilder<
                                DocumentSnapshot<Map<String, dynamic>>>(
                            stream: controller
                                .friendsStream(allChats[i]!.connection!),
                            builder: (context, snapshot2) {
                              if (snapshot2.connectionState ==
                                  ConnectionState.active) {
                                Map<String, dynamic> data = snapshot2.data!
                                    .data() as Map<String, dynamic>;
                                AppUser friendData = AppUser.fromJson(data);
                                return chatBox(allChats[i]!, friendData);
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            });
                      });
                } else {
                  return const Center(child: Text("Try to chat someone..."));
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      )
      // body: Text("bruh"),
      ,
    );
  }

  Widget chatBox(UserChat chat, AppUser friendData) {
    // final DateFormat formatter = DateFormat('jm');
    // final String dateTimeStr = ;
    bool isRead = chat.totalUnread == 0;

    return InkWell(
      onTap: () {
        controller.routeToChatRoom(
            chat.chatId!, friendData.uid!, friendData.name!);
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          width: Get.width,
          margin: EdgeInsets.only(bottom: 20.h),
          height: 80.h,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Picture container
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    // color: Colors.amber,
                    width: 80.h,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.r)),
                        image: DecorationImage(
                          image: friendData.profilePic == "" ||
                                  friendData.profilePic == null
                              ? const AssetImage(AppConstant.NO_PROFILE_PIC)
                              : Image.network(friendData.profilePic!)
                                  as ImageProvider,
                          // image: AssetImage(AppConstant.NO_PROFILE_PIC),
                          fit: BoxFit.cover,
                        )),
                  ),
                  //Online indicator, TO BE FIX HERE
                  if (true) onlineCircle(),
                ],
              ),
              SizedBox(width: 16.h),
              //Content right side wrapped into 2 row
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          chatText(friendData.name, isRead),
                          // chatText(chat.lastTime, isRead),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (chat.lastSender == appUserController.uid)
                                //Add an arrow indicator to mark the message is sent
                                const Padding(
                                  padding: EdgeInsets.only(right: 4),
                                  child: Icon(
                                    Icons.north_east,
                                    color: Colors.black,
                                    size: 16,
                                  ),
                                ),

                              //The content of the text
                              chatText(chat.lastContent ?? "", isRead),
                            ],
                          ),
                          isRead
                              ? const SizedBox()
                              : Container(
                                  width: 20.h,
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(100.r)),
                                    color: AppColors.blue,
                                  ),
                                  child: Center(
                                    child: Text(
                                      chat.totalUnread.toString(),
                                      style:
                                          AppTextStyle.c2.merge(const TextStyle(
                                        fontSize: 10,
                                        color: AppColors.white,
                                      )),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  //Text inside chatbox
  Widget chatText(content, bool status) {
    return status
        //Read so that text is unblod
        ? Text(
            content,
            maxLines: 1,
            style: AppTextStyle.c1.merge(const TextStyle(
              color: AppColors.black,
              overflow: TextOverflow.ellipsis,
            )),
          )
        : Text(
            content,
            maxLines: 1,
            style: AppTextStyle.h3.merge(const TextStyle(
              color: AppColors.black,
              overflow: TextOverflow.ellipsis,
            )),
          );
  }

  Widget onlineCircle() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 14.h,
          height: 14.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100.r)),
            color: AppColors.white,
          ),
        ),
        Container(
          width: 12.h,
          height: 12.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100.r)),
            color: AppColors.green,
          ),
        ),
      ],
    );
  }
}
