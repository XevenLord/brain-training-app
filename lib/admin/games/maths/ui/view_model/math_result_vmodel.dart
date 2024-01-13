import 'package:brain_training_app/admin/games/maths/domain/entity/math_set.dart';
import 'package:brain_training_app/admin/games/maths/domain/services/admin_math_service.dart';
import 'package:brain_training_app/common/domain/entity/math_ans.dart';
import 'package:get/get.dart';

class MathResultViewModel extends GetxController {
  List<String> _matchedUserIdList = [];
  List<MathSet> _mathAnswers = [];
  List<String> get matchedUserIdList => _matchedUserIdList;
  List<MathSet> get mathAnswers => _mathAnswers;

  Future<List<MathSet>> getMathAnswersByUserId(String userId) async {
    try {
      _mathAnswers = await AdminMathService().getMathAnswersByUserId(userId);
      update();
      return _mathAnswers;
    } catch (e) {
      print("[Admin Math View Model] Error get_mathAnswersByUserId: " +
          e.toString());
      return [];
    }
  }

  void getMathUserIdList() async {
    try {
      _matchedUserIdList = await AdminMathService().getMathUserIdList();
    } catch (e) {
      print("[Admin Math View Model] Error getMathUserIdList: " + e.toString());
      // return [];
    }
  }
}
