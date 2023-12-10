import 'package:brain_training_app/patient/game/maths/domain/services/math_service.dart';
import 'package:get/get.dart';

class MathGameViewModel extends GetxController {
  Map<String, dynamic> mathRes = {};

  setMathResult(Map<String, dynamic> res) {
    mathRes = res;
    update();
  }

  Future<bool> submitMathQuestAnswer() async {
    print("Enter Math view model");
    bool res = await MathGameService.submitQuestionWithAnswer(mathRes);
    return res;
  }
}
