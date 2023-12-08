import 'package:brain_training_app/patient/game/common/ui/game_intro.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TTTHome extends StatefulWidget {
  const TTTHome({super.key});

  @override
  State<TTTHome> createState() => _TTTHomeState();
}

class _TTTHomeState extends State<TTTHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: GameIntro(
          title: 'Tic Tac Toe Game',
          introduction:
              'Tic Tac Toe is a game where you win when you have 3 of your symbols in a row, column or diagonal.',
          img: 'assets/images/tic_tac_toe_game.png',
          gradient: AppColors.transparentBlue,
          buttonColor: AppColors.lightBlue,
          btnTextColor: AppColors.brandBlue,
          onTap: () => Get.toNamed(RouteHelper.getTicTacToe()),
        ),
      ),
    );
  }
}
