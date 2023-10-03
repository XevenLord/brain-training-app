import 'package:brain_training_app/patient/chat/ui/page/chat_home_page_unilah.dart';
import 'package:brain_training_app/patient/chat/ui/page/chat_room_page.dart';
import 'package:brain_training_app/patient/chat/ui/widget/chat_tile.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List chats = [
    {
      "imgUrl":
          "https://image.shutterstock.com/image-illustration/mathematics-horizontal-banner-presentation-website-260nw-1798855321.jpg",
      "username": "Joanne Lau",
      "lastMessage": "Please don't rainnnn!",
      "lastMessageDate": "8/6/2023",
      "lastMessageTime": "5:00pm",
    },
    {
      "imgUrl":
          "https://image.shutterstock.com/image-illustration/mathematics-horizontal-banner-presentation-website-260nw-1798855321.jpg",
      "username": "Yi Xuan",
      "lastMessage": "omggg rainnnn!",
      "lastMessageDate": "8/6/2023",
      "lastMessageTime": "5:10pm",
    },
    {
      "imgUrl":
          "https://image.shutterstock.com/image-illustration/mathematics-horizontal-banner-presentation-website-260nw-1798855321.jpg",
      "username": "Xuanie",
      "lastMessage": "Bu yaoo rainnnn!",
      "lastMessageDate": "8/6/2023",
      "lastMessageTime": "5:20pm",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        ...List.generate(chats.length, (index) {
          return ChatTile(
            imgUrl: chats[index]["imgUrl"],
            username: chats[index]["username"],
            lastMessage: chats[index]["lastMessage"],
            lastMessageDate: chats[index]["lastMessageDate"],
            lastMessageTime: chats[index]["lastMessageTime"],
            hasDivider: index != chats.length - 1,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatHomePage(),
                ),
              );
            },
          );
        })
      ],
    );
  }
}
