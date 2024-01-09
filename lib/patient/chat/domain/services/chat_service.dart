import 'package:brain_training_app/common/domain/entity/message_chat.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatService extends GetxService {
  Future<bool> sendChatMessage(MessageChat chat) async {
    print("got enter chat service");
    final appUser = Get.find<AppUser>();
    try {
      bool res = await FirebaseFirestore.instance
          .collection('chats')
          .doc(chat.uid)
          .collection('messages')
          .add({
            'uid': appUser.uid,
            'createdOn': DateTime.now(),
            'msg': chat.msg,
            'type': chat.type
          })
          .then((value) => true)
          .catchError((error) => print(error));
      return res;
    } catch (e) {
      print(e);
      return Future.value(false);
    }
  }
}
