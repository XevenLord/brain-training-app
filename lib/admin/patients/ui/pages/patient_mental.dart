import 'dart:math';

import 'package:brain_training_app/admin/appointments/ui/pages/appointment_main_page.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/healthCheck/ui/view_model/mental_quiz_vmodel.dart';
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
    setState(() {});
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () {
                  Get.back();
                  dispose();
                },
                icon: Icon(Icons.arrow_back)),
            Text("Mental Health Result",
                style: AppTextStyle.h2.merge(AppTextStyle.brandBlueTextStyle)),
          ],
        ),
        if (mentalHealthResult.entries.isEmpty)
          Center(child: CircularProgressIndicator())
        else
          ...mentalHealthResult.entries
              .map((entry) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(entry.key, style: AppTextStyle.h1),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.edit,
                                    color: AppColors.brandBlue),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10.w),
                        ...entry.value.entries.map((innerEntry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              width: double.maxFinite,
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.shade300, width: 1.w),
                                  borderRadius: BorderRadius.circular(8.w),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(innerEntry.key, style: AppTextStyle.h3),
                                  Text(innerEntry.value.toString(),
                                      style: AppTextStyle.h2.merge(
                                          AppTextStyle.brandBlueTextStyle)),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ))
              .toList(),
      ],
    )));
  }
}
