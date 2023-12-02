import 'package:brain_training_app/common/ui/widget/screen.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdminHomePage extends StatelessWidget {
  AdminHomePage({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> categories = [
    {
      "category": "Appointment",
      "icon": Icons.calendar_month,
      "onTap": () {
        Get.toNamed(RouteHelper.getAdminAppointmentPage());
      }
    },
    {"category": "Patient", "icon": Icons.person_pin_rounded, "onTap": () {}},
    {"category": "Game Result", "icon": IconData(0xf43b), "onTap": () {}},
    {"category": "Reminder", "icon": Icons.notifications, "onTap": () {}},
    {
      "category": "Admin",
      "icon": Icons.admin_panel_settings,
      "onTap": () {
        Get.toNamed(RouteHelper.getAdminListPage());
      }
    },
    {"category": "Survey", "icon": Icons.edit_document, "onTap": () {}},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.linearBluePurple,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 10.w,
                  right: 8.w,
                  top: 20.h,
                  bottom: 28.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, Mr. Ryan",
                          style: AppTextStyle.h3
                              .merge(AppTextStyle.whiteTextStyle),
                        ),
                        Text(
                          "NeuroFit Dashboard",
                          style: AppTextStyle.h2
                              .merge(AppTextStyle.whiteTextStyle),
                        )
                      ],
                    ),
                    Image.asset(AppConstant.NEUROFIT_LOGO_ONLY, width: 80.w),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              alignment: Alignment.centerLeft,
              child: Text("Categories", style: AppTextStyle.h2),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h, // Added mainAxisSpacing
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      ...categories.map((category) => InkWell(
                            onTap: category["onTap"],
                            child: Container(
                              margin: EdgeInsets.only(top: 10.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    category["icon"],
                                    size: 50.w,
                                    color: AppColors.brandBlue,
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    category["category"],
                                    style: AppTextStyle.h4.merge(
                                      AppTextStyle.brandBlueTextStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
