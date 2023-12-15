import 'package:brain_training_app/common/ui/widget/empty_box.dart';
import 'package:brain_training_app/common/ui/widget/icon_box.dart';
import 'package:brain_training_app/common/ui/widget/screen.dart';
import 'package:brain_training_app/patient/appointment/domain/entity/physiotherapist.dart';
import 'package:brain_training_app/patient/appointment/ui/page/appointment_calendar_page.dart';
import 'package:brain_training_app/patient/appointment/ui/view_model/appointment_vmodel.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppointmentBookingPage extends StatefulWidget {
  AppointmentBookingPage({
    super.key,
  });

  @override
  State<AppointmentBookingPage> createState() => _AppointmentBookingPageState();
}

class _AppointmentBookingPageState extends State<AppointmentBookingPage> {
  late AppointmentViewModel _appointmentViewModel;
  late AppUser physiotherapist;

  @override
  void initState() {
    super.initState();
    _appointmentViewModel = Get.find<AppointmentViewModel>();
    physiotherapist = _appointmentViewModel.chosenPhysiotherapist!;
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      appBarTitle: "Appointment",
      hasHorizontalPadding: false,
      noBackBtn: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                width: double.maxFinite,
                height: 480.h,
                decoration: BoxDecoration(
                  gradient: AppColors.linearBlueProfile,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50.r),
                    bottomRight: Radius.circular(50.r),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 70.r,
                      backgroundImage: NetworkImage(
                        physiotherapist.profilePic!,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      physiotherapist.name!,
                      style: AppTextStyle.h2.merge(AppTextStyle.whiteTextStyle),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      physiotherapist.position!,
                      style: AppTextStyle.c1.merge(AppTextStyle.whiteTextStyle),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(height: 40.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconBox(
                          icon: Icon(Icons.message, color: AppColors.brandBlue),
                          title: "Messaging",
                          boxColor: AppColors.lightBlue,
                          textStyle: AppTextStyle.brandBlueTextStyle,
                        ),
                        IconBox(
                          icon: Icon(Icons.phone, color: AppColors.brandBlue),
                          title: "Audio Call",
                          boxColor: AppColors.lightBlue,
                          textStyle: AppTextStyle.brandBlueTextStyle,
                        ),
                        IconBox(
                          icon:
                              Icon(Icons.videocam, color: AppColors.brandBlue),
                          title: "Video Call",
                          boxColor: AppColors.lightBlue,
                          textStyle: AppTextStyle.brandBlueTextStyle,
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
              Positioned(
                top: 16.h,
                left: 8.w,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "About Physiotherapist",
                  style: AppTextStyle.h3,
                ),
                SizedBox(height: 8.h),
                Text(
                  physiotherapist.aboutMe!,
                  style: AppTextStyle.c2,
                ),
                SizedBox(height: 24.h),
                Text(
                  "Working Time",
                  style: AppTextStyle.h3,
                ),
                SizedBox(height: 8.h),
                Text(
                  "Mon - Sat (08:30 AM - 09:00 PM)",
                  style: AppTextStyle.c2,
                ),
              ],
            ),
          )
        ],
      ),
      bottomWidget: EmptyBox(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.brandBlue,
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppointmentCalendarPage(),
              ),
            );
          },
          child: Text(
            "Book Appointment",
            style: AppTextStyle.h3.merge(AppTextStyle.whiteTextStyle),
          ),
        ),
      ),
    );
  }
}
