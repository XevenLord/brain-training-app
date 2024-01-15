import 'package:brain_training_app/common/domain/entity/message_chat.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatService extends GetxService {
  Future<bool> sendChatMessage(MessageChat chat, String targetUid) async {
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
      }).then((value) async {
        // Update isRead in the main chat document
        await FirebaseFirestore.instance
            .collection('chats')
            .doc(chat.uid)
            .update({
          'isRead': {
            appUser.uid: true, // Assuming the current user just sent a message
            // Update the targetUid based on your logic
            // e.g., Get the targetUid from the chat document or use a default value
            targetUid: false,
          }
        });
        return true;
      }).catchError((error) {
        print(error);
        return false;
      });
      return res;
    } catch (e) {
      print(e);
      return Future.value(false);
    }
  }
}
