import 'package:brain_training_app/admin/mmse/domain/entity/patient_response.dart';
import 'package:brain_training_app/admin/mmse/domain/entity/question.dart';
import 'package:brain_training_app/admin/mmse/domain/services/mmse_service.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:get/get.dart';

class MMSEViewModel extends GetxController {
  List<Question> questions = [];
  List<PatientResponse> patientResponses = [];

  Future<List<Question>> loadQuestions() async {
    if (questions.isNotEmpty) return questions;
    questions = await MMSEService.loadQuestions();
    update();
    return questions;
  }

  Future<void> submitAnswers(List<Question> quests, AppUser patient) async {
    List<Map<String, dynamic>> answers = [];
    int score = 0;

    for (int i = 0; i < quests.length; i++) {
      Question question = quests[i];
      List<String> selectedOptions = [];

      for (int j = 0; j < question.options.length; j++) {
        if (question.options[j].isSelected) {
          selectedOptions.add((j + 1).toString());
          score++;
        }
      }

      answers.add({
        'questionId': i + 1,
        'selectedOptions': selectedOptions,
      });
    }

    MMSEService.submitAnswer(answers, score, patient.uid!);
  }

  Future<List<PatientResponse>> loadPatientResponses() async {
    try {
      if (patientResponses.isNotEmpty) return patientResponses;
      patientResponses = await MMSEService.loadPatientResponses();
      return patientResponses;
    } catch (e) {
      print('Error loading patient responses: $e');
      return [];
    }
  }
}
