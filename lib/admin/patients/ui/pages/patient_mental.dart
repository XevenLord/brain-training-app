import 'dart:math';

import 'package:brain_training_app/admin/appointments/ui/pages/appointment_main_page.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/healthCheck/ui/view_model/mental_quiz_vmodel.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PatientMentalResult extends StatefulWidget {
  AppUser patient;
  PatientMentalResult({super.key, required this.patient});

  @override
  State<PatientMentalResult> createState() => _PatientMentalResultState();
}

class _PatientMentalResultState extends State<PatientMentalResult> {
  Map<String, dynamic> mentalHealthResult = {};
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    getMentalHealthAnswerByID();
    super.initState();
  }

  void getMentalHealthAnswerByID() async {
    await Get.find<MentalQuizViewModel>()
        .getMentalHealthAnswerByID(widget.patient.uid!);
    mentalHealthResult = Get.find<MentalQuizViewModel>().mentalResult;
    isLoading = false;
    setState(() {});
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.brandBlue,
          elevation: 0,
          title: Text("Mental Health Result",
              style: AppTextStyle.h2.merge(AppTextStyle.brandBlueTextStyle)),
        ),
        body: mentalHealthResult.entries.isEmpty
            ? Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : displayEmptyDataLoaded("No data found",
                        showBackArrow: false))
            : SafeArea(
                child: SingleChildScrollView(
                child: Column(
                  children: mentalHealthResult.entries
                      .map((entry) => Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ExpansionTile(
                              title: Text(entry.key,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.h2),
                              children: (entry.value.entries
                                  .map<Widget>((innerEntry) {
                                return Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Container(
                                    width: double.maxFinite,
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade300,
                                            width: 1.w),
                                        borderRadius:
                                            BorderRadius.circular(8.w),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 2,
                                            offset: const Offset(0, 3),
                                          ),
                                        ]),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(innerEntry.key,
                                            style: AppTextStyle.h3),
                                        Text(innerEntry.value.toString(),
                                            style: AppTextStyle.h2.merge(
                                                AppTextStyle
                                                    .brandBlueTextStyle)),
                                      ],
                                    ),
                                  ),
                                );
                              })).toList(),
                            ),
                          ))
                      .toList(),
                ),
              )));
  }
}
