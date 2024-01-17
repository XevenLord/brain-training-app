import 'package:brain_training_app/patient/game/2048/tzfe_vmodel.dart';
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
                ' Imagine it like a sliding puzzle where you combine matching numbered tiles to create bigger ones. The goal? Merge your way up to that elusive tile labeled 2048. It\'s like a digital strategy game that\'s easy to pick up but offers endless fun as you figure out the best moves to conquer the grid.',
            img: 'assets/images/2048_game.png',
            gradient: AppColors.transparentRed,
            buttonColor: AppColors.lightRed,
            btnTextColor: AppColors.brandRed,
            actions: IconButton(
              onPressed: () => Get.toNamed(RouteHelper.getTZFEScorePage()),
              icon: Icon(Icons.leaderboard),
            ),
            onTap: () {
              Get.find<TZFEViewModel>().setGridSize(Level.Medium);
              Get.toNamed(RouteHelper.getTZFEGame(), arguments: Level.Medium);
            }),
      ),
    );
  }
}
