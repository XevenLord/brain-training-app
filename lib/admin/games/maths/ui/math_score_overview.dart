import 'package:brain_training_app/admin/games/maths/domain/entity/math_set.dart';
import 'package:brain_training_app/admin/games/maths/ui/math_ans_row.dart';
import 'package:brain_training_app/admin/games/maths/ui/view_model/math_result_vmodel.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MathScoreOverview extends StatefulWidget {
  AppUser patient;
  List<MathSet>? mathAns;
  MathScoreOverview({super.key, required this.patient, this.mathAns});

  @override
  State<MathScoreOverview> createState() => _MathScoreOverviewState();
}

class _MathScoreOverviewState extends State<MathScoreOverview> {
  late MathResultViewModel mathResultViewModel =
      Get.find<MathResultViewModel>();
  List<MathSet> mathAnswers = [];
  int index = 1;
  bool isLoading = true;

  @override
  void initState() {
    mathAnswers = widget.mathAns!;
    isLoading = false;
    // mathAnswers.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));
    setState(() {});
    print("Math Answers: " + mathResultViewModel.mathAnswers.toString());
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
        title: Text('Arithmetic Score Overview', style: AppTextStyle.h2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: mathAnswers.isEmpty
            ? Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : displayEmptyDataLoaded(
                        "There is no data of Arithmetic Score yet.",
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
                    ...mathAnswers.map((mathAns) {
                      return ExpansionTile(
                        title: Text(mathAns.id ?? "",
                            style: AppTextStyle
                                .h3), // Assuming 'id' is a property of MathAnswer
                        children: mathAns.maths!.map((math) {
                          MathAnsRow row = MathAnsRow(
                            mathAnswer: math,
                            index: index++,
                          );
                          return row;
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
