import 'package:brain_training_app/common/domain/entity/tzfe_score_set.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/game/2048/tzfe_vmodel.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TZFEScorePage extends StatefulWidget {
  TZFEScorePage({super.key});

  @override
  State<TZFEScorePage> createState() => _TZFEScorePageState();
}

class _TZFEScorePageState extends State<TZFEScorePage> {
  late TZFEViewModel tZFEViewModel = Get.find<TZFEViewModel>();
  late AppUser patient;
  List<TZFEScoreSet> tZFEScoreSet = [];
  int index = 1;
  bool isLoading = true;

  @override
  void initState() {
    patient = Get.find<AppUser>();
    getTZFEScores();
    setState(() {});
    print("tzfeScoreSet: " + tZFEViewModel.tzfeScoreSet.toString());
    super.initState();
  }

  void getTZFEScores() async {
    tZFEScoreSet = await tZFEViewModel.getTZFEScores();
    isLoading = false;
    setState(() {});
  }

  String calculateAge(DateTime? dateOfBirth) {
    if (dateOfBirth == null) {
      return 'N/A';
    }

    final currentDate = DateTime.now();
    final age = currentDate.year - dateOfBirth.year;

    if (currentDate.month < dateOfBirth.month ||
        (currentDate.month == dateOfBirth.month &&
            currentDate.day < dateOfBirth.day)) {
      return (age - 1)
          .toString(); // Subtract 1 if birthday hasn't occurred this year yet
    }

    return age.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.brandBlue,
        title: Text('2048 Score Overview', style: AppTextStyle.h2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: tZFEScoreSet.isEmpty
            ? Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : displayEmptyDataLoaded("There is no 2048 score yet!",
                        showBackArrow: false))
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(children: [
                    SizedBox(height: 10.h),
                    Row(
                      // mainAxisAlignment: MainAxisAlignments.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 32.r,
                          backgroundColor: AppColors.lightBlue,
                          backgroundImage: (patient.profilePic == null ||
                                  patient.profilePic!.isEmpty)
                              ? const AssetImage(
                                  AppConstant.NO_PROFILE_PIC,
                                ) as ImageProvider
                              : NetworkImage(patient.profilePic!),
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(patient.name!, style: AppTextStyle.h2),
                            Text("Age: ${calculateAge(patient.dateOfBirth)}",
                                style: AppTextStyle.h3),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    ...tZFEScoreSet.map((scoreSet) {
                      return ExpansionTile(
                        title: Text(scoreSet.id ?? "",
                            style: AppTextStyle
                                .h3), // Assuming 'id' is a property of MathAnswer
                        children: scoreSet.tzfeScores.map((tzfeScore) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${DateFormat.jm().format(tzfeScore.timestamp!.toDate())}',
                                  style: AppTextStyle.h3,
                                ),
                                Text(
                                  '${tzfeScore.status.toUpperCase()}',
                                  style: AppTextStyle.h3.merge(TextStyle(
                                      color: tzfeScore.status == 'win'
                                          ? Colors.green
                                          : Colors.red)),
                                ),
                                Text(
                                  '${tzfeScore.score.toString()} scores',
                                  style: AppTextStyle.h3,
                                ),
                                Text(
                                  '${tzfeScore.duration.toString()} seconds',
                                  style: AppTextStyle.h3,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ]),
                ),
              ),
      ),
    );
  }
}
