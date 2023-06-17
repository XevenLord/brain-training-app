import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Image.asset(AppConstant.FORGET_PASSWORD),
            SizedBox(height: 16.h),
            Text("Forget Password", style: AppTextStyle.h2),
            SizedBox(height: 16.h),
            Text(
              "Enter your email address below and we'll send you a link to reset your password.",
              textAlign: TextAlign.center,
              style: AppTextStyle.c1,
            ),
            SizedBox(height: 64.h),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Email Address",
                hintText: "Enter your email address",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("Send Link"),
            ),
          ],
        ),
      ),
    );
  }
}
