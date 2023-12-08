import 'package:brain_training_app/common/ui/widget/information_row.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdminOverview extends StatefulWidget {
  AppUser admin;

  AdminOverview({required this.admin, super.key});

  @override
  State<AdminOverview> createState() => _AdminOverviewState();
}

class _AdminOverviewState extends State<AdminOverview> {
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
            child: widget.admin.profilePic != null &&
                    widget.admin.profilePic!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(60.r),
                    child: Image(
                      image: NetworkImage(widget.admin.profilePic! as String),
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
          Text(widget.admin.name!, style: AppTextStyle.h2),
          InformationRow(
              title: "Age",
              value: calculateAge(widget.admin.dateOfBirth),
              padding: EdgeInsets.only(top: 10.w)),
          InformationRow(
              title: "Gender",
              value: widget.admin.gender!,
              padding: EdgeInsets.only(top: 8.w)),
          InformationRow(
              title: "Phone Number",
              value: widget.admin.phoneNumber!,
              padding: EdgeInsets.only(top: 8.w)),
          InformationRow(
              title: "Email",
              value: widget.admin.email!,
              padding: EdgeInsets.only(top: 8.w, bottom: 16.w)),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 40.w,
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
                  SizedBox(height: 10.w),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 16.0),
                      textStyle: const TextStyle(fontSize: 14),
                    ),
                    onPressed: () {},
                    child: const Text('Edit Admin Profile'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.w),

          // May can have a list of admin's patients here
          // or a list of admin's appointments
        ]),
      ),
    );
  }
}
