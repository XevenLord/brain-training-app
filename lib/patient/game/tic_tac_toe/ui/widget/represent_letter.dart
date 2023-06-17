import 'package:brain_training_app/patient/game/tic_tac_toe/domain/entity/tic_tac_toe.dart';
import 'package:brain_training_app/patient/game/tic_tac_toe/ui/view_model/settings_controller.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RepresentLetter extends StatelessWidget {
  final GameLetter letter;
  final double? width;
  
  const RepresentLetter(this.letter, {Key? key, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      init: SettingsController(),
      builder: (settingsController) {
        return Image.asset(
          letter == GameLetter.x? AppConstant.TIC_TAC_TOE_X : AppConstant.TIC_TAC_TOE_O,
          width: width,
        );
      }
    );
  }
}