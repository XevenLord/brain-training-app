import 'package:brain_training_app/patient/game/common/ui/game_intro.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MathHome extends StatefulWidget {
  const MathHome({super.key});

  @override
  State<MathHome> createState() => _MathHomeState();
}

class _MathHomeState extends State<MathHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: GameIntro(
          title: 'Math Game',
          introduction:
              'You will be given a simple math question, answer it as fast as you can!',
          img: 'assets/images/mathematics_game.png',
          actions: IconButton(
            onPressed: () => Get.toNamed(RouteHelper.getMathScorePage()),
            icon: Icon(Icons.leaderboard),
          ),
          onTap: () => Get.toNamed(RouteHelper.getMathDifficultyPage()),
        ),
      ),
    );
  }
}
