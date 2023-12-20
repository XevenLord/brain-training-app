import 'package:brain_training_app/admin/games/maths/ui/math_ans_row.dart';
import 'package:brain_training_app/admin/games/maths/ui/view_model/math_result_vmodel.dart';
import 'package:brain_training_app/common/domain/entity/math_ans.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MathScoreOverview extends StatefulWidget {
  AppUser patient;
  List<MathAnswer>? mathAns;
  MathScoreOverview({super.key, required this.patient, this.mathAns});

  @override
  State<MathScoreOverview> createState() => _MathScoreOverviewState();
}

class _MathScoreOverviewState extends State<MathScoreOverview> {
  late MathResultViewModel mathResultViewModel =
      Get.find<MathResultViewModel>();
  List<MathAnswer> mathAnswers = [];
  int index = 1;

  @override
  void initState() {
    mathAnswers = widget.mathAns ?? [];
    mathAnswers.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));
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
        title: const Text('Maths Score Overview'),
        elevation: 0,
      ),
      body: SafeArea(
        child: mathAnswers.isEmpty
            ? Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppConstant.EMPTY_DATA,
                        width: 200,
                        height: 200,
                      ),
                      Text("There is no data of Maths Score yet.",
                          style: AppTextStyle.h2
                              .merge(AppTextStyle.brandBlueTextStyle))
                    ]),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(children: [
                  SizedBox(height: 10.h),
                  Row(
                    // mainAxisAlignment: MainAxisAlignments.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 32.r,
                        child: widget.patient.profilePic != null &&
                                widget.patient.profilePic!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(32.r),
                                child: Image(
                                  image:
                                      NetworkImage(widget.patient.profilePic!),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fill,
                                ))
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                width: 100,
                                height: 100,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey[800],
                                )),
                      ),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.patient.name!, style: AppTextStyle.h2),
                          Text("Age: ${calculateAge(widget.patient.dateOfBirth)}",
                              style: AppTextStyle.h3),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  ...mathAnswers.map((mathAns) {
                    MathAnsRow row = MathAnsRow(
                      mathAnswer: mathAns,
                      index: index++,
                    );
                    return row;
                  }).toList(),
                ]),
              ),
      ),
    );
  }
}
