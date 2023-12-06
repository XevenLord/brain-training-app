import 'package:brain_training_app/patient/appointment/ui/view_model/appointment_vmodel.dart';
import 'package:brain_training_app/patient/chat/ui/pages/chat.dart';
import 'package:brain_training_app/patient/chat/ui/view_model/chat_vmodel.dart';
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
  AppointmentViewModel appointmentViewModel = Get.find<AppointmentViewModel>();

  @override
  void initState() {
    chatViewModel = Get.find<ChatViewModel>();
    chatViewModel.refreshChatsForCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CupertinoSearchTextField(
              key: UniqueKey(),
              onChanged: (value) {},
              onSubmitted: (value) {},
            ),
          )),
          Obx(() => SliverList(
                  delegate: SliverChildListDelegate(
                      chatViewModel.messages.values.toList().map((data) {
                var physio = appointmentViewModel.physiotherapistList
                    .firstWhereOrNull((e) => e.name == data['targetName']);
                return CupertinoListTile(
                    padding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          // maybe use physio name to be key to retrieve the imgUrl
                          physio!.imgUrl ?? ""),
                    ),
                    title: Text(data['targetName'] ?? ""),
                    subtitle: Text(data['msg'] ?? ""),
                    onTap: () => {
                          Get.to(Chat(
                              targetName: data['targetName'],
                              targetUid: physio.id))
                        });
              }).toList())))
        ],
      ),
    );
  }
}
