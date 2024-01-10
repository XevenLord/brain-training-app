import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppointmentSuccessPage extends StatelessWidget {
  const AppointmentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Image.asset(AppConstant.APPOINTMENT_SUCCESS, width: 100.w)),
              SizedBox(height: 30.h),
              Text("Appointment request is sent! Please wait for the confirmation.", style: AppTextStyle.h2,
                  textAlign: TextAlign.center,),
              SizedBox(height: 50.h),
              ElevatedButton(
                onPressed: () {
                  Get.offAndToNamed(RouteHelper.getMyAppointmentPage());
                },
                child: Text("Done", style: AppTextStyle.h2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
