import 'package:brain_training_app/patient/game/common/ui/game_intro.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TZFEHome extends StatefulWidget {
  const TZFEHome({super.key});

  @override
  State<TZFEHome> createState() => _TZFEHomeState();
}

class _TZFEHomeState extends State<TZFEHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: GameIntro(
          title: '2048 Game',
          introduction:
              'A 2048 game is a single-player sliding block puzzle game. The game\'s objective is to slide numbered tiles on a grid to combine them to create a tile with the number 2048.',
          img: 'assets/images/2048_game.png',
          gradient: AppColors.transparentRed,
          buttonColor: AppColors.lightRed,
          btnTextColor: AppColors.brandRed,
          actions: IconButton(
            onPressed: () => Get.toNamed(RouteHelper.getTZFEScorePage()),
            icon: Icon(Icons.leaderboard),
          ),
          onTap: () =>
              Get.toNamed(RouteHelper.getTZFEGame(), arguments: Level.Easy),
        ),
      ),
    );
  }
}
