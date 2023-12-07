import 'package:brain_training_app/admin/home/ui/view_model/home_vmodel.dart';
import 'package:brain_training_app/common/ui/widget/category_card_interface.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final List<Map<String, dynamic>> categories = [
    {
      "category": "Appointment",
      "icon": Icons.calendar_month,
      "onTap": () {
        Get.toNamed(RouteHelper.getAdminAppointmentPage());
      }
    },
    {
      "category": "Patient",
      "icon": Icons.person_pin_rounded,
      "onTap": () {
        Get.toNamed(RouteHelper.getPatientListPage());
      }
    },
    {
      "category": "Game Result",
      "icon": Icons.gamepad,
      "onTap": () {},
    },
    {
      "category": "Reminder",
      "icon": Icons.notifications,
      "onTap": () {},
    },
    {
      "category": "Admin",
      "icon": Icons.admin_panel_settings,
      "onTap": () {
        Get.toNamed(RouteHelper.getAdminListPage());
      }
    },
    {
      "category": "Survey",
      "icon": Icons.edit_document,
      "onTap": () {},
    },
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
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 12.w),
                          child: Image.asset(AppConstant.NEUROFIT_LOGO_ONLY,
                              width: 44.w),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hi, ${Get.find<AppUser>().name}",
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
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Get.find<AdminHomeViewModel>().signOutUser(context);
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              alignment: Alignment.centerLeft,
              child: Text("Categories",
                  style:
                      AppTextStyle.h2.merge(AppTextStyle.brandBlueTextStyle)),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 16.w, right: 16.w, bottom: 32.w),
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h, // Added mainAxisSpacing
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ...categories
                          .map((category) => CategoryCard().buildCategoryCard(
                                category: category["category"],
                                icon: category["icon"],
                                onTap: category["onTap"],
                                iconSize: 50.w,
                                foregroundColor: AppColors.brandBlue,
                                backgroundColor: Colors.white,
                                isRow: false,
                              ))
                          .toList(),
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
