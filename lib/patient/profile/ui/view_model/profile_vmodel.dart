import 'package:brain_training_app/patient/profile/domain/service/profile_service.dart';
import 'package:get/get.dart';

class ProfileViewModel extends GetxController implements GetxService {
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    bool isUpdated = false;
    isUpdated = await ProfileService.onUpdateProfileDetails(data);
    
    update();
    return isUpdated;
  }
}
