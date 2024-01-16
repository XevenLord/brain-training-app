import 'package:brain_training_app/common/domain/service/user_repo.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/chat/ui/pages/chat.dart';
import 'package:brain_training_app/patient/chat/ui/view_model/chat_vmodel.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
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
      setState(() {
        isLoading = false;
      });
      debugModePrint(e);
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
              key: PageStorageKey("chatList"),
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
                                backgroundImage: (user.profilePic == null ||
                                        user.profilePic!.isEmpty)
                                    ? const AssetImage(
                                        AppConstant.NO_PROFILE_PIC,
                                      ) as ImageProvider
                                    : NetworkImage(user.profilePic!),
                              ),
                              title: Text(user.name ?? ""),
                              onTap: () => {
                                    Get.to(Chat(
                                        targetName: user.name,
                                        targetUid: user.uid))
                                  });
                        }).toList()),
                      )
                    : Obx(
                        () => SliverList(
                          delegate: chatViewModel.messages.values
                                  .toList()
                                  .isEmpty
                              ? SliverChildListDelegate([
                                  SizedBox(height: 20.w),
                                  displayEmptyDataLoaded("No chats found",
                                      showBackArrow: false)
                                ])
                              : SliverChildListDelegate(
                                  chatViewModel.messages.values
                                      .toList()
                                      .map((data) {
                                    var physio = allAdmins.firstWhereOrNull(
                                        (e) => e.name == data['targetName']);

                                    bool isRead = (data['isRead'] != null &&
                                        data['isRead'] == true);

                                    bool isSender = data['targetUid'] ==
                                        chatViewModel.currentUser!;

                                    return CupertinoListTile(
                                        padding: EdgeInsets.zero,
                                        leading: CircleAvatar(
                                          backgroundImage: (physio
                                                          ?.profilePic ==
                                                      null ||
                                                  physio!.profilePic!.isEmpty)
                                              ? const AssetImage(
                                                  AppConstant.NO_PROFILE_PIC,
                                                ) as ImageProvider
                                              : NetworkImage(
                                                  physio.profilePic!),
                                        ),
                                        title: Text(
                                          data['targetName'] ?? "",
                                          style: isRead
                                              ? AppTextStyle.h3.merge(
                                                  TextStyle(fontSize: 18.sp))
                                              : AppTextStyle.h3.merge(TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.sp)),
                                        ),
                                        subtitle: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                data['msg'].toString().startsWith(
                                                        "https://firebasestorage.googleapis.com")
                                                    ? "[Image]"
                                                    : data['msg'] ?? "",
                                                style: isRead
                                                    ? AppTextStyle.c1.merge(
                                                        const TextStyle(
                                                            color: AppColors
                                                                .black))
                                                    : AppTextStyle.c1.merge(
                                                        const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: AppColors
                                                                .black)),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 30.w,
                                              child: isRead
                                                  ? isSender
                                                      ? null
                                                      : Icon(Icons.done_all,
                                                          color: AppColors.blue,
                                                          size: 14.sp)
                                                  : Icon(Icons.circle,
                                                      color: Colors.red,
                                                      size: 12.sp),
                                            )
                                          ],
                                        ),
                                        onTap: () => {
                                              Get.to(Chat(
                                                  key: UniqueKey(),
                                                  targetName:
                                                      data['targetName'],
                                                  targetUid: physio!.uid))
                                            });
                                  }).toList(),
                                ),
                        ),
                      )
              ],
            ),
    );
  }
}
