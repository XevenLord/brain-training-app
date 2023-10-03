import 'package:brain_training_app/common/ui/widget/screen.dart';
import 'package:brain_training_app/patient/game/tic_tac_toe/domain/entity/tic_tac_toe.dart';
import 'package:brain_training_app/patient/game/tic_tac_toe/ui/page/offline_game.dart';
import 'package:brain_training_app/patient/game/tic_tac_toe/ui/widget/letter_choices.dart';
import 'package:brain_training_app/patient/game/tic_tac_toe/ui/widget/modern_switch.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GameSettings extends StatefulWidget {
  const GameSettings({Key? key}) : super(key: key);

  @override
  State<GameSettings> createState() => _GameSettingsState();
}

class _GameSettingsState extends State<GameSettings> {
  GameLetter letter = GameLetter.none;
  bool stupidAi = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                      child: const Icon(Icons.arrow_back_ios),
                      onTap: () => Get.back()),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: const Center(
                  child: Text(
                    "Pick your side",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: OrientationBuilder(builder: (context, orientation) {
                  return SizedBox(
                    width: Get.mediaQuery.orientation == Orientation.landscape
                        ? 250
                        : null,
                    child: LetterChoices(onChange: (value) {
                      setState(() {
                        letter = value;
                      });
                    }),
                  );
                }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Unbeatable',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ModernSwitch(
                          controller: stupidAi,
                          onTap: (newState) {
                            setState(() {
                              stupidAi = newState;
                            });
                          },
                          activeColor: AppColors.brandBlue,
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Easy',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SizedBox(
                    width: Get.width / 2.5,
                    child: TextButton(
                      onPressed: () {
                        Get.to(
                          () => Game(
                            playerLetter: letter,
                            stupidAi: stupidAi,
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: AppColors.white,
                          primary: AppColors.brandBlue,
                          elevation: 7,
                          shape: const StadiumBorder(),
                          shadowColor: Colors.blue.shade200),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Continue'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
