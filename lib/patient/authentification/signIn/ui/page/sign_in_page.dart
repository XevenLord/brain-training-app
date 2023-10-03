import 'package:brain_training_app/common/ui/widget/input_text_field.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/service/auth_repo.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  final TextEditingController _emailInput = TextEditingController();
  final TextEditingController _passwordInput = TextEditingController();

  bool obscureText = true;

  void showMessage(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(title: Text(errorMessage));
      },
    );
  }

  void _signUserIn() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      await FirebaseAuthRepository.signInWithEmailAndPassword(
          email: _emailInput.text, password: _passwordInput.text);
      debugModePrint("null check getCurrentUser " +
          (FirebaseAuthRepository.getCurrentUser() == null).toString());
      debugModePrint("null check get find uid " +
          (Get.find<AppUser>().uid == null).toString());
      Get.offAllNamed(RouteHelper.getPatientHome());
    } on FirebaseAuthException catch (e) {
      Get.back();
      //wrong Email
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              children: [
                Image.asset(AppConstant.WRONG_MARK, width: 100.w),
                SizedBox(height: 10.h),
                Text("Wrong email or password entered!",
                    textAlign: TextAlign.center, style: AppTextStyle.h3),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 16.w),
          child: FormBuilder(
            key: _fbKey,
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      Image.asset(AppConstant.NEUROFIT_LOGO_ONLY, width: 100.w),
                      SizedBox(height: 16.h),
                      Text("Welcome", style: AppTextStyle.h2),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                InputTextFormField(
                  name: "email",
                  promptText: "Email",
                  textEditingController: _emailInput,
                  label: "Enter Your Email",
                  keyboardType: TextInputType.emailAddress,
                ),
                InputTextFormField(
                  name: "password",
                  promptText: "Password",
                  textEditingController: _passwordInput,
                  label: "Enter Your Password",
                  keyboardType: TextInputType.emailAddress,
                  obscureText: obscureText,
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                    child: Icon(Icons.remove_red_eye),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(RouteHelper.getForgetPassword());
                    },
                    child: Text("Forget Password"),
                  ),
                ),
                SizedBox(height: 30.h),
                Center(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _signUserIn();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brandBlue),
                        child: Text(
                          "Sign In",
                          style: AppTextStyle.h2,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: AppTextStyle.h3
                                .merge(AppTextStyle.blackTextStyle),
                          ),
                          InkWell(
                            onTap: () => Get.offAllNamed(
                                RouteHelper.getSignUpFirstPage()),
                            child: Text(
                              "Sign Up",
                              style: AppTextStyle.h3.merge(AppTextStyle
                                  .brandBlueTextStyle
                                  .merge(AppTextStyle.underlineTextStyle)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
