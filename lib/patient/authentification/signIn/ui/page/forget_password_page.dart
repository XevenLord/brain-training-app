import 'package:brain_training_app/patient/authentification/signUp/domain/service/auth_repo.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController _emailInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: AppColors.brandBlue),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(height: 64.h),
              Image.asset(AppConstant.FORGET_PASSWORD,
                  width: MediaQuery.of(context).size.width * 0.5),
              SizedBox(height: 16.h),
              Text("Forget Password", style: AppTextStyle.h2),
              SizedBox(height: 16.h),
              Text(
                "Enter your email address below and we'll send you a link to reset your password.",
                textAlign: TextAlign.center,
                style: AppTextStyle.c1,
              ),
              SizedBox(height: 50.h),
              TextFormField(
                controller: _emailInput,
                decoration: InputDecoration(
                  labelText: "Email Address",
                  hintText: "Enter your email address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: AppColors.brandBlue),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: () {
                    FirebaseAuthRepository.sendPasswordResetEmail(
                        email: _emailInput.text);
                  },
                  child: const Text("Send Link"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
