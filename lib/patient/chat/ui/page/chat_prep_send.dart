import 'dart:io';

import 'package:brain_training_app/patient/chat/ui/view_model/chat_prep_send_vmodel.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';


class ChatPrepSendPage extends GetView<ChatPrepSendViewModel> {
  final String imagePath =
      (Get.arguments as Map<String, dynamic>)["imagePath"] ?? "";
  final XFile imageFile =
      (Get.arguments as Map<String, dynamic>)["imageFile"] ?? "";
  final String chatId = (Get.arguments as Map<String, dynamic>)["chatId"] ?? "";
  final String friendUid =
      (Get.arguments as Map<String, dynamic>)["friendUid"] ?? "";
  final String friendName =
      (Get.arguments as Map<String, dynamic>)["friendName"] ?? "";

  ChatPrepSendPage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("is Prep friendUid ${friendUid}");

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              child: Image.file(File(imagePath)),
            ),
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  controller.deleteFile(imagePath);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: const [
                    Icon(
                      Icons.circle,
                      color: Colors.white24,
                      size: 70,
                    ),
                    Icon(
                      Icons.cancel_schedule_send,
                      color: Colors.white,
                      size: 30,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  //Todo
                  controller.sendImage(chatId, friendUid, imageFile, imagePath);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: const [
                    Icon(
                      Icons.circle,
                      color: Colors.white24,
                      size: 70,
                    ),
                    Icon(
                      Icons.send_sharp,
                      color: Colors.white,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
