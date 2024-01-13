import 'package:brain_training_app/patient/home/domain/service/feedback_service.dart';
import 'package:get/get.dart';

class FeedbackViewModel extends GetxController {
  Future<void> submitFeedback(String feedback) async {
    await FeedbackService.submitFeedback(feedback);
  }
}
