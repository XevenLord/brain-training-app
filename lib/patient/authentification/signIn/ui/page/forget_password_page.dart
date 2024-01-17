import 'package:brain_training_app/patient/authentification/signUp/domain/service/auth_repo.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final TextEditingController _emailInput = TextEditingController();

  void sendLink() async {
    _fbKey.currentState!.save();
    if (_fbKey.currentState!.saveAndValidate()) {
      await FirebaseAuthRepository.sendPasswordResetEmail(
          email: _emailInput.text);
      _emailInput.clear();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text("Reset Password", style: AppTextStyle.h2),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AppConstant.DONE_CHECK,
                      width: MediaQuery.of(context).size.width * 0.5),
                  Text(
                      "A link has been sent to your email address. Please check your email to reset your password.",
                      style: AppTextStyle.h3),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                    Get.back();
                  },
                  child: Text(
                    "OK",
                    style:
                        AppTextStyle.h3.merge(AppTextStyle.brandBlueTextStyle),
                  ),
                ),
              ],
            );
          });
    }
  }

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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FormBuilder(
              key: _fbKey,
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
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                      hintText: "Enter your email address",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide:
                            const BorderSide(color: AppColors.brandBlue),
                      ),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: "Please enter your email",
                      ),
                      FormBuilderValidators.email(),
                    ]),
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
                        sendLink();
                      },
                      child: const Text("Send Link"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
