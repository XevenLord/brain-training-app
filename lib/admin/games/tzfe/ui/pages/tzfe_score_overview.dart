import 'package:brain_training_app/admin/games/tzfe/ui/view_model/tzfe_vmodel.dart';
import 'package:brain_training_app/common/domain/entity/tzfe_score_set.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TZFEScoreOverview extends StatefulWidget {
  AppUser patient;
  List<TZFEScoreSet>? tzfeScoreSets;
  TZFEScoreOverview({super.key, required this.patient, this.tzfeScoreSets});

  @override
  State<TZFEScoreOverview> createState() => _TZFEScoreOverviewState();
}

class _TZFEScoreOverviewState extends State<TZFEScoreOverview> {
  late AdminTZFEViewModel adminTZFEVModel = Get.find<AdminTZFEViewModel>();
  List<TZFEScoreSet> tzfeScoreSets = [];
  int index = 1;
  bool isLoading = true;

  @override
  void initState() {
    print("tzfe score overview param: " + widget.tzfeScoreSets.toString());
    tzfeScoreSets = widget.tzfeScoreSets!;
    isLoading = false;
    // mathAnswers.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));
    setState(() {});
    print("tzfeScoreSet: " + adminTZFEVModel.tzfeScoreSet.toString());
    super.initState();
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
        child: tzfeScoreSets.isEmpty
            ? Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : displayEmptyDataLoaded("There is no 2048 score yet.",
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
                          backgroundImage: (widget.patient.profilePic == null ||
                                  widget.patient.profilePic!.isEmpty)
                              ? const AssetImage(
                                  AppConstant.NO_PROFILE_PIC,
                                ) as ImageProvider
                              : NetworkImage(widget.patient.profilePic!),
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.patient.name!, style: AppTextStyle.h2),
                            Text(
                                "Age: ${calculateAge(widget.patient.dateOfBirth)}",
                                style: AppTextStyle.h3),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    ...tzfeScoreSets.map((tzfeScoreSet) {
                      return ExpansionTile(
                        title: Text(tzfeScoreSet.id ?? "",
                            style: AppTextStyle
                                .h3), // Assuming 'id' is a property of MathAnswer
                        children: tzfeScoreSet.tzfeScores.map((tzfeScore) {
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
