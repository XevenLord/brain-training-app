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
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: GameIntro(
          title: 'Flip Card Memory Game',
          introduction:
              'A memory flip card game tests your recall by matching pairs of hidden cards.',
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
    );
  }
}
