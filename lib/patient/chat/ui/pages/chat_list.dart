import 'package:brain_training_app/patient/chat/ui/pages/chat.dart';
import 'package:brain_training_app/patient/chat/ui/view_model/chat_vmodel.dart';
import 'package:brain_training_app/patient/chat/ui/widgets/chat_item.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  late ChatViewModel chatViewModel;

  @override
  void initState() {
    // TODO: implement initState
    chatViewModel = Get.find<ChatViewModel>();
    chatViewModel.refreshChatsForCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  CustomScrollView(
                slivers: [
                  SliverList(
                      delegate: SliverChildListDelegate(chatViewModel.messages.values.toList().map((data) {
                        return CupertinoListTile(title: Text(data['targetName']), subtitle: Text(data['msg']), onTap: () => {});
                      }).toList()))
                ],
              );
  }
}
