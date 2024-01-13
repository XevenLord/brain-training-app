import 'package:brain_training_app/admin/games/tzfe/domain/service/admin_tzfe_service.dart';
import 'package:brain_training_app/common/domain/entity/tzfe_score_set.dart';
import 'package:get/get.dart';

class AdminTZFEViewModel extends GetxController {
  List<String> _matchedUserIdList = [];
  List<TZFEScoreSet> _tzfeScoreSet = [];
  List<String> get matchedUserIdList => _matchedUserIdList;
  List<TZFEScoreSet> get tzfeScoreSet => _tzfeScoreSet;

  Future<List<TZFEScoreSet>> getTZFEScoreSetByUserId(String uid) async {
    try {
      _tzfeScoreSet = await AdminTZFEService.getTZFEScoreSetByUserId(uid);
      update();
      return _tzfeScoreSet;
    } catch (e) {
      print(
          "[Admin TZFE Model] Error getTZFEScoreSetByUserId: " + e.toString());
      return [];
    }
  }

  void getTZFEUserIdList() async {
    try {
      _matchedUserIdList = await AdminTZFEService.getTZFEUserIdList();
    } catch (e) {
      print("[Admin TZFE View Model] Error getTZFEUserIdList: " + e.toString());
      // return [];
    }
  }
}
