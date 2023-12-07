import 'package:brain_training_app/common/domain/service/user_repo.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/chat/ui/pages/chat.dart';
import 'package:brain_training_app/patient/chat/ui/view_model/chat_vmodel.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  late ChatViewModel chatViewModel;
  late UserRepository userRepo;
  List<AppUser> users = [];
  bool isLoading = true;

  @override
  void initState() {
    userRepo = Get.find<UserRepository>();
    fetchAllUsers();
    chatViewModel = Get.find<ChatViewModel>();
    chatViewModel.refreshChatsForCurrentUser();
    super.initState();
  }

  void fetchAllUsers() async {
    try {
      await userRepo.fetchAllUsers();
      setState(() {
        users = userRepo.getAllUsers;
        isLoading = false;
      });
    } catch (e) {
      debugModePrint(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: isLoading
              ? const Align(
                  alignment: Alignment.topCenter,
                  child: CircularProgressIndicator())
              : CustomScrollView(
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
                          var physio = users.firstWhereOrNull(
                              (e) => e.name == data['targetName']);
                          return CupertinoListTile(
                              padding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    physio!.profilePic ?? ""),
                              ),
                              title: Text(data['targetName'] ?? ""),
                              subtitle: Text(data['msg'] ?? ""),
                              onTap: () => {
                                    Get.to(Chat(
                                        targetName: data['targetName'],
                                        targetUid: physio.uid))
                                  });
                        }).toList())))
                  ],
                ),
        ),
      ),
    );
  }
}
