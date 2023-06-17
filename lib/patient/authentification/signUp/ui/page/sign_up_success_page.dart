import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignUpDonePage extends StatelessWidget {
  const SignUpDonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Image.asset(AppConstant.DONE_CHECK, width: 100.w)),
              SizedBox(height: 16),
              Text(
                "Sign Up Success",
                style: AppTextStyle.h1,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30.h),
              // Text(
              //   "Please check your email to verify your account",
              //   style: AppTextStyle.h2,
              //   textAlign: TextAlign.center,
              // ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Get.offAllNamed(RouteHelper.getSignIn());
                },
                child: Text("Go to Login", style: AppTextStyle.h2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
