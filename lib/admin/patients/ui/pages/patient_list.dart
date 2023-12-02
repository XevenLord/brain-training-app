import 'package:brain_training_app/common/ui/widget/info_card.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdminList extends StatefulWidget {
  const AdminList({super.key});

  @override
  State<AdminList> createState() => _AdminListState();
}

class _AdminListState extends State<AdminList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text("Patient List",
              style: AppTextStyle.brandBlueTextStyle.merge(AppTextStyle.h2)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.brandBlue),
          onPressed: () => Get.back(), // Or Get.back() if using GetX
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoCardTile().buildInfoCard(
                name: "Mr. Pua",
                age: "20",
                gender: "Male",
                position: "Admin",
              ),
              InfoCardTile().buildInfoCard(
                name: "Mr. Lee",
                age: "50",
                gender: "Male",
                position: "Assistant",
              ),
              InfoCardTile().buildInfoCard(
                name: "Mr. Tay",
                age: "60",
                gender: "Male",
                position: "Assistant",
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 30.w),
                  child: Column(
                    children: [
                      IconButton(
                        iconSize: 60.w,
                        icon: Icon(Icons.add_circle,
                            color: Colors.blue, size: 60.w),
                        onPressed: () {},
                      ),
                      Text("Add New Admin",
                          style: AppTextStyle.h3
                              .merge(AppTextStyle.brandBlueTextStyle)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
