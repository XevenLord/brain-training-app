import 'package:brain_training_app/common/ui/widget/screen.dart';
import 'package:brain_training_app/patient/chat/ui/widget/chat_item.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({super.key});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  List<Map> chatInfo = [
    {
      "isSender": false,
      "message": "Hello, how are you?",
      "type": "text",
    },
    {
      "isSender": true,
      "message": "I'm fine, thank you. How are you?",
      "type": "text",
    },
    {
      "isSender": false,
      "message": "I'm great, thanks for asking.",
      "type": "text",
    },
    {
      "isSender": true,
      "message": "No problem!",
      "type": "text",
    },
    {
      "isSender": false,
      "message": "Bye!",
      "type": "text",
    },
    {
      "isSender": true,
      "message": "Bye!",
      "type": "text",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Screen(
      hasHorizontalPadding: false,
      appBar: AppBar(
        foregroundColor: AppColors.brandBlue,
        backgroundColor: AppColors.white,
        centerTitle: true,
        title: Text(
          'Chat',
          style: AppTextStyle.h2,
        ),
      ),
      noBackBtn: true,
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Text("12:00 am"),
                              SizedBox(height: 30.h),
                              ChatItem(
                                isSender: chatInfo[index]["isSender"],
                                message: chatInfo[index]["message"],
                                type: chatInfo[index]["type"],
                              ),
                            ],
                          );
                        },
                        itemCount: chatInfo.length,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomChatTool(),
        ],
      ),
    );
  }

  Widget bottomChatTool() {
    return Container(
      // color: Colors.amber,
      height: 120.h,
      width: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(30.w, 30.h, 30.w, 30.h),
      child: Row(children: [
        //TextField
        Expanded(
          child: Obx(() {
            return FormBuilderTextField(
              // onTap: () {
              //   Timer(Duration.zero, () {
              //     controller.scrollC
              //         .jumpTo(controller.scrollC.position.maxScrollExtent);
              //   });
              // },
              autocorrect: false,
              onEditingComplete: () {},
              onChanged: (value) {},
              style: (AppTextStyle.c1.merge(AppTextStyle.blackTextStyle))
                  .merge(const TextStyle(fontWeight: FontWeight.normal)),
              decoration: InputDecoration(
                //Camera function
                suffixIcon: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                          width: 60.h,
                          alignment: Alignment.center,
                          child: const FaIcon(
                            FontAwesomeIcons.camera,
                            color: AppColors.brandBlue,
                            size: 24,
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        // controller.selectImage(chatId, friendUid);
                      },
                      child: Container(
                          width: 60.h,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.image,
                            color: AppColors.brandBlue,
                            size: 24,
                          )),
                    ),
                  ],
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
                filled: true,
                fillColor: AppColors.white,
                hintText: "Send Message",
                hintStyle: AppTextStyle.c1,
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.white),
                    borderRadius: BorderRadius.circular(10),
                    gapPadding: 0),
                disabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.white),
                    borderRadius: BorderRadius.circular(10),
                    gapPadding: 0),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.brandBlue),
                    borderRadius: BorderRadius.circular(10),
                    gapPadding: 0),
                focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 2, color: Colors.red),
                    borderRadius: BorderRadius.circular(10),
                    gapPadding: 0),
                errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10),
                    gapPadding: 0),
              ),
              name: "msg",
            );
          }),
        ),
        SizedBox(width: 16.w),

        //Send message
        Obx(() {
          // GestureDetector(
          //     onLongPress: () {
          //       debugModePrint("Start Recording");
          //     },
          //     onLongPressUp: () {
          //       debugModePrint("End Recording");
          //     },
          //     child: Container(
          //         decoration: BoxDecoration(
          //           color: AppColors.blue,
          //           borderRadius: BorderRadius.circular(10),
          //         ),
          //         width: 60.h,
          //         alignment: Alignment.center,
          //         child: const FaIcon(
          //           FontAwesomeIcons.microphone,
          //           color: AppColors.white,
          //         )),
          //   )
          //Voice Message
          return InkWell(
            onTap: () {
              // controller.newChat(
              //     chatId, friendUid, controller.chatC.text, "Text");
            },
            child: Container(
                decoration: BoxDecoration(
                  color: AppColors.brandBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 60.h,
                alignment: Alignment.center,
                child: const FaIcon(
                  FontAwesomeIcons.share,
                  color: AppColors.white,
                )),
          );
        })
      ]),
    );
  }
}
