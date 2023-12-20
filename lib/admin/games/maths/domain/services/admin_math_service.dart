import 'package:brain_training_app/common/domain/entity/math_ans.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminMathService {
  Future<List<MathAnswer>> getMathAnswersByUserId(String userId) async {
    try {
      List<MathAnswer> mathAnswers = [];
      var querySnapshot = await FirebaseFirestore.instance
          .collection('games')
          .doc("MathGame")
          .collection("users")
          .doc(userId)
          .collection("answers")
          .get();

      mathAnswers = querySnapshot.docs.map((doc) {
        return MathAnswer.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
      return mathAnswers;
    } catch (e) {
      print("Error Admin Math Service: " + e.toString());
      return [];
    }
  }

  Future<List<String>> getMathUserIdList() async {
    try {
      List<String> userIdList = [];

      userIdList = await FirebaseFirestore.instance
          .collection('games')
          .doc("MathGame")
          .collection("users")
          .get()
          .then((value) => value.docs.map((e) => e.id).toList());

      print("Admin Math Service: " + userIdList.toString());
      return userIdList;
    } catch (e) {
      print("[Admin Math Service] Error getMathUserIdList: " + e.toString());
      return [];
    }
  }
}
