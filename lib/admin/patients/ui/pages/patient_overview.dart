import 'package:brain_training_app/common/ui/widget/category_card_interface.dart';
import 'package:brain_training_app/common/ui/widget/information_row.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PatientOverview extends StatefulWidget {
  AppUser patient;

  PatientOverview({required this.patient, super.key});

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
          Get.toNamed(RouteHelper.getAdminGameCategoriesPage());
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
          print("ontap appt patient");
          Get.toNamed(RouteHelper.getPatientMentalResultPage(),
              arguments: widget.patient);
        },
      },
      {
        "category": "MMSE Result",
        "icon": Icons.edit_attributes_rounded,
        "gradient": const LinearGradient(
          colors: <Color>[
            Color(0xFFFE7F44),
            Color(0xFFFFCF68),
          ],
        ),
        "onTap": () {},
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.brandBlue),
          onPressed: () => Get.back(), // Or Get.back() if using GetX
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(children: [
          CircleAvatar(
            radius: 60.r,
            child: widget.patient.profilePic != null &&
                    widget.patient.profilePic!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(60.r),
                    child: Image(
                      image: NetworkImage(widget.patient.profilePic! as String),
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
              padding: EdgeInsets.only(top: 8.w, bottom: 16.w)),
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(4),
          //   child: SizedBox(
          //     height: 40.w,
          //     child: Stack(
          //       children: <Widget>[
          //         Positioned.fill(
          //           child: Container(
          //             decoration: const BoxDecoration(
          //               gradient: LinearGradient(
          //                 colors: <Color>[
          //                   Color(0xFF0D47A1),
          //                   Color(0xFF1976D2),
          //                   Color(0xFF42A5F5),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ),
          //         TextButton(
          //           style: TextButton.styleFrom(
          //             foregroundColor: Colors.white,
          //             padding: const EdgeInsets.symmetric(
          //                 vertical: 4, horizontal: 16.0),
          //             textStyle: const TextStyle(fontSize: 14),
          //           ),
          //           onPressed: () {},
          //           child: const Text('Edit Patient Profile'),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          SizedBox(height: 20.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("History Records", style: AppTextStyle.h2),
              // TextButton(
              //   onPressed: () {},
              //   child: Text("PDF"),
              // ),
            ],
          ),
          SizedBox(height: 20.w),
          Expanded(
            child: SingleChildScrollView(
              child: ListView.builder(
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
            ),
          ),
        ]),
      ),
    );
  }
}
