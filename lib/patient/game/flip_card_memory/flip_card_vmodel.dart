import 'package:brain_training_app/admin/games/flipcard/domain/entity/flipcard_set.dart';
import 'package:brain_training_app/patient/game/flip_card_memory/flip_card_service.dart';
import 'package:get/get.dart';

class FlipCardViewModel extends GetxController {
  List<FlipCardSet> flipCardSet = [];

  Future<List<FlipCardSet>> getFlipCardSet() async {
    flipCardSet = await FlipCardService.getFlipCardSet();
    return flipCardSet;
  }
}
