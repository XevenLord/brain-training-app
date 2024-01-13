import 'package:brain_training_app/admin/games/flipcard/domain/entity/flipcard_set.dart';
import 'package:brain_training_app/admin/games/flipcard/domain/services/flipcard_service.dart';
import 'package:get/get.dart';

class AdminFlipCardViewModel extends GetxController {
  List<String> _matchedUserIdList = [];
  List<FlipCardSet> _flipCardRes = [];
  List<String> get matchedUserIdList => _matchedUserIdList;
  List<FlipCardSet> get flipCardRes => _flipCardRes;

  Future<List<FlipCardSet>> getFlipCardSetByUserId(String userId) async {
    try {
      _flipCardRes =
          await AdminFlipCardService().getFlipCardSetByUserId(userId);
      update();
      return _flipCardRes;
    } catch (e) {
      print("[Admin FC View Model] Error getFlipCardSetByUserId: " +
          e.toString());
      return [];
    }
  }

  void getFlipCardUserIdList() async {
    try {
      _matchedUserIdList = await AdminFlipCardService().getFlipCardUserIdList();
    } catch (e) {
      print("[Admin FC View Model] Error getFlipCardUserIdList: " + e.toString());
      // return [];
    }
  }
}
