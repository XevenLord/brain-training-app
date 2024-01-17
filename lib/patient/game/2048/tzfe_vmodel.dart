import 'package:brain_training_app/common/domain/entity/tzfe_score_set.dart';
import 'package:brain_training_app/patient/game/2048/services/tzfe_service.dart';
import 'package:get/get.dart';

class TZFEViewModel extends GetxController {
  List<TZFEScoreSet> tzfeScoreSet = [];

  Future<void> submitScore(int score, bool status, Duration duration) async {
    await TZFEService.submitScore(score, status ? 'win' : 'lose', duration);
  }

  Future<List<TZFEScoreSet>> getTZFEScores() async {
    tzfeScoreSet = await TZFEService.getTZFEScores();
    return tzfeScoreSet;
  }
}
