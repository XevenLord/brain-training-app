import 'package:brain_training_app/common/domain/entity/message_chat.dart';
import 'package:brain_training_app/common/domain/entity/type_mesage.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/chat/ui/view_model/chat_vmodel.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Chat extends StatefulWidget {
  final targetName;
  final targetUid;
  Chat({super.key, this.targetName, this.targetUid});

  @override
  State<Chat> createState() => _ChatState(targetName, targetUid);
}

class _ChatState extends State<Chat> {
  late ChatViewModel chatViewModel;
  CollectionReference chats = FirebaseFirestore.instance.collection("chats");
  final targetName;
  final targetUid;
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  var chatDocId;
  final TextEditingController _textController = new TextEditingController();
  DateTime? currentDate;

  _ChatState(this.targetName, this.targetUid);
  @override
  void initState() {
    checkUser();
    chatViewModel = Get.find<ChatViewModel>();
    super.initState();
  }

  void checkUser() async {
    QuerySnapshot querySnapshot = await chats
        .where('users', isEqualTo: {targetUid: null, currentUserId: null})
        .limit(1)
        .get()
        .catchError((error) => print("Failed to get chats: $error"));

    if (querySnapshot.docs.isNotEmpty) {
      bool existingTargetUid = false;

      String docId = querySnapshot.docs.single.id;

      if ((querySnapshot.docs.single.data() as Map?)?.containsKey('isRead') ??
          false) {
        existingTargetUid =
            (querySnapshot.docs.single.data() as Map?)?['isRead'][targetUid] ??
                false;
        await chats.doc(docId).update({
          'isRead': {
            currentUserId: true,
            targetUid: existingTargetUid,
          }
        });
      } else {
        await chats.doc(docId).set(
          {
            'isRead': {
              currentUserId: true,
              targetUid: existingTargetUid,
            }
          },
          SetOptions(merge: true),
        );
      }

      setState(() {
        chatDocId = docId;
      });
    } else {
      await chats.add({
        'users': {
          currentUserId: null,
          targetUid: null,
        },
        'names': {
          currentUserId: Get.find<AppUser>().name,
          targetUid: targetName
        },
        'isRead': {
          currentUserId: true,
          targetUid: false,
        }
      }).then((value) => setState(() {
            chatDocId = value.id;
          }));
    }
  }

  void sendTextMessage(String? uid) {
    String msg = _textController.text.trim();

    if (msg.isEmpty) return;

    MessageChat chat = MessageChat(
        uid: chatDocId,
        createdOn: DateTime.now(),
        msg: msg,
        type: TypeMessage.text);
    _textController.clear();
    chatViewModel.sendTextMessage(chat, targetUid);
  }

  void sendImageMessage(String? uid) {
    MessageChat chat = MessageChat(
        uid: chatDocId, createdOn: DateTime.now(), type: TypeMessage.image);
    chatViewModel.sendImageMessage(chat, targetUid);
  }

  bool isSender(String friend) {
    return friend == currentUserId;
  }

  Alignment getAlignment(friend) {
    if (friend == currentUserId) {
      return Alignment.topRight;
    } else {
      return Alignment.topLeft;
    }
  }

  @override
  Widget build(BuildContext context) {
    return chatDocId == null
        ? const Material(child: Center(child: CircularProgressIndicator()))
        : Material(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("chats")
                    .doc(chatDocId)
                    .collection('messages')
                    .orderBy('createdOn', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: const Text('Something went wrong'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasData) {
                    dynamic data;
                    return CupertinoPageScaffold(
                      navigationBar: CupertinoNavigationBar(
                        middle: Text(targetName),
                      ),
                      child: SafeArea(
                        child: Column(
                          children: [
                            Expanded(
                                child: ListView(
                                    reverse: true,
                                    children: snapshot.data!.docs
                                        .map((DocumentSnapshot document) {
                                      data = document.data()!;

                                      DateTime messageDate =
                                          data['createdOn'] == null
                                              ? DateTime.now()
                                              : data['createdOn'].toDate();

                                      bool showDate = currentDate == null ||
                                          currentDate != messageDate;
                                      currentDate = messageDate;

                                      if (data['msg'] != null &&
                                          data['msg'].toString().isURL &&
                                          data['msg'].toString().startsWith(
                                              "https://firebasestorage.googleapis.com")) {
                                        String url = data['msg'];
                                        return InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Dialog(
                                                  insetPadding: EdgeInsets.zero,
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .height,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: Image.network(
                                                        url,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 20,
                                                left:
                                                    data['uid'] == currentUserId
                                                        ? 0
                                                        : 8,
                                                right:
                                                    data['uid'] == currentUserId
                                                        ? 8
                                                        : 0),
                                            alignment: getAlignment(
                                                data['uid'].toString()),
                                            height: 200.h,
                                            width: 200.w,
                                            child: Image.network(url),
                                          ),
                                        );
                                      } else {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),

                                          // check is image in firebase
                                          // only firebasefirestore is allowed
                                          child: Column(
                                            children: [
                                              if (showDate)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: Text(
                                                    messageDate
                                                            .toLocal()
                                                            .toString()
                                                            .split(' ')[
                                                        0], // Display only the date.
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12.w,
                                                    ),
                                                  ),
                                                ),
                                              ChatBubble(
                                                clipper: ChatBubbleClipper6(
                                                  nipSize: 0,
                                                  radius: 4,
                                                  type: isSender(data['uid']
                                                          .toString())
                                                      ? BubbleType.sendBubble
                                                      : BubbleType
                                                          .receiverBubble,
                                                ),
                                                alignment: getAlignment(
                                                    data['uid'].toString()),
                                                margin:
                                                    EdgeInsets.only(top: 20),
                                                backGroundColor: isSender(
                                                        data['uid'].toString())
                                                    ? Colors.blue
                                                    : Colors.grey[200],
                                                child: Container(
                                                  constraints: BoxConstraints(
                                                    maxWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                                data['msg'],
                                                                style:
                                                                    TextStyle(
                                                                  color: isSender(
                                                                          data['uid']
                                                                              .toString())
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                  fontSize: 16,
                                                                ),
                                                                maxLines: 100,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            data['createdOn'] ==
                                                                    null
                                                                ? DateTime.now()
                                                                    .toString()
                                                                : DateFormat(
                                                                        "HH:mm")
                                                                    .format(data[
                                                                            'createdOn']
                                                                        .toDate()),
                                                            style: TextStyle(
                                                                color: isSender(
                                                                        data['uid']
                                                                            .toString())
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                                fontSize: 8.w),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    }).toList())),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.only(left: 18.0),
                                  child: CupertinoTextField(
                                    controller: _textController,
                                  ),
                                )),
                                CupertinoButton(
                                    child: Icon(Icons.image),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              height: 150.h,
                                              child: Column(
                                                children: [
                                                  ListTile(
                                                    leading: const Icon(
                                                      Icons.camera_alt,
                                                      color:
                                                          AppColors.brandBlue,
                                                    ),
                                                    title: Text("Camera"),
                                                    onTap: () async {
                                                      Navigator.pop(context);
                                                      await chatViewModel
                                                          .takeImageFromCamera();
                                                      sendImageMessage(
                                                          data['uid']
                                                              .toString());
                                                    },
                                                  ),
                                                  ListTile(
                                                    leading: const Icon(
                                                      Icons.photo,
                                                      color:
                                                          AppColors.brandBlue,
                                                    ),
                                                    title: Text("Gallery"),
                                                    onTap: () async {
                                                      Navigator.pop(context);
                                                      await chatViewModel
                                                          .takeImageFromGallery();
                                                      sendImageMessage(
                                                          data?['uid']
                                                              ?.toString());
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    }),
                                CupertinoButton(
                                    child: Icon(Icons.send_sharp),
                                    onPressed: () => sendTextMessage(
                                        data?['uid']?.toString()))
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  return Container();
                }),
          );
  }
}
