import 'package:brain_training_app/common/domain/entity/tzfe_score_set.dart';
import 'package:brain_training_app/patient/game/2048/services/tzfe_service.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:get/get.dart';

class TZFEViewModel extends GetxController {
  List<TZFEScoreSet> tzfeScoreSet = [];
  int gridSize = 4;

  Future<void> submitScore(int score, bool status, Duration duration) async {
    await TZFEService.submitScore(score, status ? 'win' : 'lose', duration);
  }

  Future<List<TZFEScoreSet>> getTZFEScores() async {
    tzfeScoreSet = await TZFEService.getTZFEScores();
    return tzfeScoreSet;
  }

  void clearTZFEScores() {
    tzfeScoreSet.clear();
  }

  void setGridSize(Level level) {
    switch (level) {
      case Level.Easy:
        gridSize = 6;
        break;
      case Level.Medium:
        gridSize = 4;
        break;
      case Level.Hard:
        gridSize = 3;
        break;
    }
  }

  int getGridSize() {
    return gridSize;
  }
}
