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
        child: SingleChildScrollView(
          child: GameIntro(
            title: 'Tic Tac Toe Game',
            introduction:
                'Tic Tac Toe is a game where you win when you have 3 of your symbols in a row, column or diagonal.\n\nGame Modes:\nUnbeatable Mode: Prepare for the ultimate challenge! Our unbeatable robot opponent employs advanced algorithms to make every move count. Can you outsmart the machine and claim victory?\n\nEasy Mode: Perfect for casual play, the easy mode allows beginners and leisure gamers to enjoy the classic fun of Tic Tac Toe without breaking a sweat.',
            img: 'assets/images/tic_tac_toe_game.png',
            gradient: AppColors.transparentBlue,
            buttonColor: AppColors.lightBlue,
            btnTextColor: AppColors.brandBlue,
            onTap: () => Get.toNamed(RouteHelper.getTicTacToe()),
          ),
        ),
      ),
    );
  }
}
