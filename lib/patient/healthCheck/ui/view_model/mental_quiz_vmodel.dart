import 'package:brain_training_app/patient/healthCheck/domain/services/mental_quest_service.dart';
import 'package:brain_training_app/patient/profile/domain/service/profile_service.dart';
import 'package:get/get.dart';

class MentalQuizViewModel extends GetxController {
  Map<String, dynamic> mentalResult = {};

  Future<bool> submitMentalHealthAnswer(Map<String, String> answers) async {
    bool res = await MentalQuestService.submitMentalHealthAnswer(answers);

    if (res) {
      bool profileUpdated = await ProfileService.onUpdateProfileDetails({
        "mentalQuiz": DateTime.now().toString()
      });
      return profileUpdated;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> getMentalHealthAnswerByID(String uid) async {
    print("Mental Quiz View Model: Getting mental quiz");
    mentalResult = await MentalQuestService.getMentalHealthAnswerByID(uid);
    return mentalResult;
  }
}
