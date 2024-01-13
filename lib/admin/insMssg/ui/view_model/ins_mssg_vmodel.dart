import 'package:brain_training_app/admin/insMssg/domain/services/ins_mssg_service.dart';
import 'package:brain_training_app/admin/patients/domain/entity/inspirational_mssg.dart';
import 'package:get/get.dart';

class InspirationalMssgViewModel extends GetxController implements GetxService {
  List<InspirationalMessage> insMssgs = [];

  Future<void> getGeneralInspirationalMessages() async {
    if (insMssgs.isEmpty) {
      insMssgs =
          await InspirationalMssgService.getGeneralInspirationalMessages();
    }
  }

  Future<void> addInspirationalMessage(
      InspirationalMessage inspirationalMessage) async {
    await InspirationalMssgService.onPushGeneralInspirationalMessage(
        inspirationalMessage);
    insMssgs.add(inspirationalMessage);
  }

  Future<void> deleteInspirationalMessage(
      InspirationalMessage inspirationalMessage) async {
    await InspirationalMssgService.onDeleteGeneralInspirationalMessage(
        inspirationalMessage);
    insMssgs.remove(inspirationalMessage);
  }

  void updateInspirationalMessage(
      InspirationalMessage inspirationalMessage) async {
    await InspirationalMssgService.onUpdateGeneralInspirationalMessage(
        inspirationalMessage);
  }
}
