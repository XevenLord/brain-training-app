import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Chat extends StatefulWidget {
  final targetName;
  final targetUid;
  Chat({super.key, this.targetName, this.targetUid});

  @override
  State<Chat> createState() => _ChatState(targetName, targetUid);
}

class _ChatState extends State<Chat> {
  CollectionReference chats = FirebaseFirestore.instance.collection("chats");
  final targetName;
  final targetUid;
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  var chatDocId;
  TextEditingController _textController = new TextEditingController();

  _ChatState(this.targetName, this.targetUid);
  @override
  void initState() {
    checkUser();
    super.initState();
  }

  void checkUser() async {
    await chats
        .where('users', isEqualTo: {targetUid: null, currentUserId: null})
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) async {
          if (querySnapshot.docs.isNotEmpty) {
            setState(() {
              chatDocId = querySnapshot.docs.single.id;
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
              }
            }).then((value) => chatDocId = value);
          }
        })
        .catchError((error) => print("Failed to get chats: $error"));
  }

  void sendMessage(String msg) {
    if (msg.isEmpty) return;
    chats.doc(chatDocId).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'uid': currentUserId,
      'msg': msg
    }).then((value) {
      _textController.clear();
    });
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
    return Material(
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("chats")
              .doc(chatDocId)
              .collection('messages')
              .orderBy('createdOn', descending: true)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: const Text('Something went wrong'));
            }
    
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
    
            if (snapshot.hasData) {
              var data;
              return CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                    previousPageTitle: "Back",
                    middle: Text(targetName),
                    trailing: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        child: Icon(CupertinoIcons.phone))),
                child: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                          child: ListView(
                              reverse: true,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                data = document.data()!;
    
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: ChatBubble(
                                    clipper: ChatBubbleClipper6(
                                      nipSize: 0,
                                      radius: 4,
                                      type: isSender(data['uid'].toString())
                                          ? BubbleType.sendBubble
                                          : BubbleType.receiverBubble,
                                    ),
                                    alignment:
                                        getAlignment(data['uid'].toString()),
                                    margin: EdgeInsets.only(top: 20),
                                    backGroundColor:
                                        isSender(data['uid'].toString())
                                            ? Colors.blue
                                            : Colors.grey[200],
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Text(data['msg'],
                                                    style: TextStyle(
                                                      color: isSender(data['uid']
                                                              .toString())
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                    maxLines: 100,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                data['createdOn'] == null
                                                    ? DateTime.now().toString()
                                                    : data['createdOn']
                                                        .toDate()
                                                        .toString(),
                                                style: TextStyle(
                                                    color: isSender(data['uid']
                                                            .toString())
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontSize: 8.w),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList())),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child:
                                CupertinoTextField(controller: _textController),
                          )),
                          CupertinoButton(
                              child: Icon(Icons.send_sharp),
                              onPressed: () => sendMessage(_textController.text))
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
