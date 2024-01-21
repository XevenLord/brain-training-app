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
        child: SingleChildScrollView(
          child: GameIntro(
            title: 'Arithmetic Game',
            introduction:
                'Arithmetic Game presents you with a series of arithmetic operations, ranging from easy to hard difficulty levels. You\'ll encounter addition, subtraction, multiplication, and division problems involving two numbers. Use the provided math calculator keypad to input your answers quickly and accurately.',
            img: 'assets/images/mathematics_game.png',
            actions: IconButton(
              onPressed: () => Get.toNamed(RouteHelper.getMathScorePage()),
              icon: Icon(Icons.leaderboard),
            ),
            onTap: () => Get.toNamed(RouteHelper.getMathDifficultyPage()),
          ),
        ),
      ),
    );
  }
}
