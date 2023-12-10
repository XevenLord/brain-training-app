import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';

class MathScoreOverview extends StatefulWidget {
  AppUser patient;
  MathScoreOverview({super.key, required this.patient});

  @override
  State<MathScoreOverview> createState() => _MathScoreOverviewState();
}

class _MathScoreOverviewState extends State<MathScoreOverview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.brandBlue,
        title: const Text('Maths Score Overview'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              AppConstant.EMPTY_DATA,
              width: 200,
              height: 200,
            ),
            Text("There is no data of Maths Score yet.",
                style: AppTextStyle.h2.merge(AppTextStyle.brandBlueTextStyle))
          ]),
        ),
      ),
    );
  }
}
