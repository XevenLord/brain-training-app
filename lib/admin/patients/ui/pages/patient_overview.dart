import 'package:brain_training_app/admin/appointments/domain/entity/appointment.dart';
import 'package:brain_training_app/common/ui/widget/category_card_interface.dart';
import 'package:brain_training_app/common/ui/widget/icon_box.dart';
import 'package:brain_training_app/common/ui/widget/information_row.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/chat/ui/pages/chat.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PatientOverview extends StatefulWidget {
  AppUser patient;
  AdminAppointment appointment;

  PatientOverview(
      {required this.patient, required this.appointment, super.key});

  @override
  State<PatientOverview> createState() => _PatientOverviewState();
}

class _PatientOverviewState extends State<PatientOverview> {
  List historyCategories = [];

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
  void initState() {
    historyCategories = [
      {
        "category": "Game",
        "icon": Icons.gamepad,
        "gradient": const LinearGradient(
          colors: <Color>[
            Color(0xFFFF6C60),
            Color(0xFFFF484C),
          ],
        ),
        "onTap": () {
          Get.toNamed(RouteHelper.getAdminGameCategoriesPage(),
              arguments: widget.patient);
        },
      },
      {
        "category": "Appointment",
        "icon": Icons.calendar_month,
        "gradient": const LinearGradient(
          colors: <Color>[
            Color(0xFF2753F3),
            Color(0xFF765AFC),
          ],
        ),
        "onTap": () {
          print("ontap appt patient");
          Get.toNamed(RouteHelper.getPatientApptPage(),
              arguments: widget.patient);
        },
      },
      {
        "category": "Mental Health Check",
        "icon": Icons.health_and_safety_rounded,
        "gradient": const LinearGradient(
          colors: <Color>[
            Color(0xFF2EA13A),
            Color(0xFF41D73E),
          ],
        ),
        "onTap": () {
          Get.toNamed(RouteHelper.getPatientMentalResultPage(),
              arguments: widget.patient);
        },
      },
      {
        "category": "MMSE Screening",
        "icon": Icons.edit_attributes_rounded,
        "gradient": const LinearGradient(
          colors: <Color>[
            Color(0xFFFE7F44),
            Color(0xFFFFCF68),
          ],
        ),
        "onTap": () {
          Get.toNamed(RouteHelper.getMmseQuestionnaire(),
              arguments: widget.patient);
        },
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Get.to(Chat(
                targetName: widget.patient.name,
                targetUid: widget.patient.uid,
              ));
            },
            icon: const Icon(Icons.message, color: AppColors.brandBlue),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.brandBlue),
          onPressed: () => Get.back(), // Or Get.back() if using GetX
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(children: [
            CircleAvatar(
              radius: 60.r,
              backgroundColor: AppColors.lightBlue,
              backgroundImage: (widget.patient.profilePic == null ||
                      widget.patient.profilePic!.isEmpty)
                  ? const AssetImage(
                      AppConstant.NO_PROFILE_PIC,
                    ) as ImageProvider
                  : NetworkImage(widget.patient.profilePic!),
            ),
            SizedBox(height: 10.w),
            Text(widget.patient.name!, style: AppTextStyle.h2),
            InformationRow(
                title: "Age",
                value: calculateAge(widget.patient.dateOfBirth),
                padding: EdgeInsets.only(top: 10.w)),
            InformationRow(
                title: "Gender",
                value: widget.patient.gender!,
                padding: EdgeInsets.only(top: 8.w)),
            InformationRow(
                title: "Phone Number",
                value: widget.patient.phoneNumber!,
                padding: EdgeInsets.only(top: 8.w)),
            InformationRow(
                title: "Email",
                value: widget.patient.email!,
                padding: EdgeInsets.only(top: 8.w)),
            InformationRow(
                title: "Stroke Level",
                value: widget.patient.strokeType ?? "N/A",
                padding: EdgeInsets.only(top: 8.w, bottom: 16.w)),
            SizedBox(height: 20.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Latest Remark", style: AppTextStyle.h2),
                SizedBox(height: 10.w),
                Text(
                  widget.appointment.remark ?? "N/A",
                  style: AppTextStyle.c2
                      .merge(TextStyle(fontStyle: FontStyle.italic)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 20.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("History Records", style: AppTextStyle.h2),
              ],
            ),
            SizedBox(height: 20.w),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: historyCategories.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CategoryCard().buildCategoryCard(
                    category: historyCategories[index]["category"],
                    icon: historyCategories[index]["icon"],
                    gradient: historyCategories[index]["gradient"],
                    onTap: historyCategories[index]["onTap"],
                  ),
                );
              },
            ),
          ]),
        ),
      ),
    );
  }
}
