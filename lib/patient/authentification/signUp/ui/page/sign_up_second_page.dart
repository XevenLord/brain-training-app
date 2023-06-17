import 'package:brain_training_app/common/ui/widget/input_text_field.dart';
import 'package:brain_training_app/patient/authentification/signUp/ui/view_model/sign_up_controller.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class SignUpSecondPage extends StatefulWidget {
  const SignUpSecondPage({super.key});

  @override
  State<SignUpSecondPage> createState() => _SignUpSecondPageState();
}

class _SignUpSecondPageState extends State<SignUpSecondPage> {
  late SignUpController signUpController;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  final TextEditingController _passwordInput = TextEditingController();
  final TextEditingController _confirmPasswordInput = TextEditingController();

  bool obscureText = true;
  bool obscureTextConfirm = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    signUpController = Get.find<SignUpController>();
  }

  void checkPassword() {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    if (_passwordInput.text != _confirmPasswordInput.text) {
      // Get.back();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              children: [
                Image.asset(AppConstant.WRONG_MARK, width: 100.w),
                SizedBox(height: 10.h),
                Text("Password does not match",
                    textAlign: TextAlign.center, style: AppTextStyle.h3),
              ],
            ),
          );
        },
      );
      return;
    }
  }

  void signUp() {
    _fbKey.currentState!.save();
    if (_fbKey.currentState!.saveAndValidate()) {
      checkPassword();
      signUpController.signUpWithData(_fbKey.currentState!.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 16.h,
              left: 8.w,
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              child: FormBuilder(
                key: _fbKey,
                child: Column(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Image.asset(AppConstant.NEUROFIT_LOGO_ONLY,
                              width: 80.w),
                          SizedBox(height: 16.h),
                          Text("Create New Account", style: AppTextStyle.h2),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    InputTextFormField(
                      obscureText: obscureText,
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        child: Icon(Icons.remove_red_eye),
                      ),
                      name: "password",
                      promptText: "Password",
                      textEditingController: _passwordInput,
                      label: "Enter Your Password",
                      keyboardType: TextInputType.name,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Password is required!"),
                        FormBuilderValidators.minLength(8,
                            errorText:
                                "Password must be at least 8 characters long."),
                      ]),
                    ),
                    InputTextFormField(
                      obscureText: obscureTextConfirm,
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            obscureTextConfirm = !obscureTextConfirm;
                          });
                        },
                        child: Icon(Icons.remove_red_eye),
                      ),
                      name: "confirmPassword",
                      promptText: "Confirm Password",
                      textEditingController: _confirmPasswordInput,
                      label: "Enter Your Password Again",
                      keyboardType: TextInputType.number,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Confirm password is required!"),
                        FormBuilderValidators.minLength(8,
                            errorText:
                                "Password must be at least 8 characters long."),
                      ]),
                    ),
                    SizedBox(height: 30.h),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          signUp();
                        },
                        child: Text(
                          "Sign Up",
                          style: AppTextStyle.h3,
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brandBlue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
