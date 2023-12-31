import 'package:brain_training_app/common/domain/service/user_repo.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/chat/ui/pages/chat.dart';
import 'package:brain_training_app/patient/chat/ui/view_model/chat_vmodel.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  TextEditingController _searchController = new TextEditingController();
  late ChatViewModel chatViewModel;
  late UserRepository userRepo;
  late List<AppUser> allAdmins = [];
  late List<AppUser> admins = [];
  bool isLoading = true;
  bool showSearchUsers = false;

  @override
  void initState() {
    userRepo = Get.find<UserRepository>();
    fetchAdmins();
    chatViewModel = Get.find<ChatViewModel>();
    chatViewModel.refreshChatsForCurrentUser();
    super.initState();
  }

  void fetchAdmins() async {
    try {
      allAdmins = await UserRepository.fetchAllAdmins();
      setState(() {
        admins = allAdmins;
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
    return SizedBox(
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
                    // autofocus: true,
                    controller: _searchController,
                    onTap: () {
                      setState(() {
                        showSearchUsers = !showSearchUsers;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        admins = allAdmins
                            .where((element) => element.name!
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                )),
                showSearchUsers
                    ? SliverList(
                        delegate: SliverChildListDelegate(admins.map((user) {
                          return CupertinoListTile(
                              padding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(user.profilePic ?? ""),
                              ),
                              title: Text(user.name ?? ""),
                              onTap: () => {
                                    Get.to(Chat(
                                        targetName: user.name,
                                        targetUid: user.uid))
                                  });
                        }).toList()),
                      )
                    : Obx(() => SliverList(
                            delegate: SliverChildListDelegate(chatViewModel
                                .messages.values
                                .toList()
                                .map((data) {
                          var physio = allAdmins.firstWhereOrNull(
                              (e) => e.name == data['targetName']);
                          return CupertinoListTile(
                              padding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(physio!.profilePic ?? ""),
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
    );
  }
}
