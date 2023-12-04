import 'package:brain_training_app/common/ui/widget/category_card_interface.dart';
import 'package:brain_training_app/common/ui/widget/information_row.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PatientOverview extends StatefulWidget {
  const PatientOverview({super.key});

  @override
  State<PatientOverview> createState() => _PatientOverviewState();
}

class _PatientOverviewState extends State<PatientOverview> {
  List historyCategories = [];

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
        "onTap": () {},
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
        "onTap": () {},
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
        "onTap": () {},
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
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Daniel", style: AppTextStyle.h2),
                    InformationRow(
                        title: "Age",
                        value: "25",
                        padding: EdgeInsets.only(top: 10.w)),
                    InformationRow(
                        title: "Gender",
                        value: "Male",
                        padding: EdgeInsets.only(top: 4.w)),
                    InformationRow(
                        title: "Phone Number",
                        value: "011-2334333",
                        padding: EdgeInsets.only(top: 4.w)),
                    InformationRow(
                        title: "Email",
                        value: "daniel@gmail.com",
                        padding: EdgeInsets.only(top: 4.w, bottom: 10.w)),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: SizedBox(
                        height: 30.w,
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Color(0xFF0D47A1),
                                      Color(0xFF1976D2),
                                      Color(0xFF42A5F5),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 16.0),
                                textStyle: const TextStyle(fontSize: 12),
                              ),
                              onPressed: () {},
                              child: const Text('Edit Profile'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(AppConstant.ERROR_IMG, width: 150.w)
            ],
          ),
          SizedBox(height: 20.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("History Records", style: AppTextStyle.h2),
              TextButton(
                onPressed: () {},
                child: Text("PDF"),
              ),
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
