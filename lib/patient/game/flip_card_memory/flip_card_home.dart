import 'package:brain_training_app/patient/game/common/ui/game_intro.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FlipCardHome extends StatefulWidget {
  const FlipCardHome({super.key});

  @override
  State<FlipCardHome> createState() => _FlipCardHomeState();
}

class _FlipCardHomeState extends State<FlipCardHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: GameIntro(
            title: 'Flip Card Memory Game',
            introduction:
                'Simply flip cards to find matching pairs and boost your memory skills! Choose your difficulty level – easy for beginners, medium for a bit of challenge, and hard for the ultimate test. As you progress, the game increases the number of hidden cards. Enjoy beautiful card designs, easy-to-use controls, and track your progress with scores.',
            img: 'assets/images/flipcard_game.jpg',
            gradient: AppColors.transparentGreen,
            buttonColor: AppColors.lightGreen,
            btnTextColor: AppColors.brandGreen,
            actions: IconButton(
              onPressed: () => Get.toNamed(RouteHelper.getMemoryResultPage()),
              icon: Icon(Icons.leaderboard),
            ),
            onTap: () => Get.toNamed(RouteHelper.getFlipCardDifficultyPage()),
          ),
        ),
      ),
    );
  }
}
