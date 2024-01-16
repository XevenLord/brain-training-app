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
import 'package:form_builder_validators/form_builder_validators.dart';
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
  String selectedRole = "patient";

  bool resourceLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loaded();
    });
  }

  didChangeDependencies() {
    super.didChangeDependencies();
    loaded();
  }

  Future<void> loaded() async {
    debugModePrint("sign page: enter loaded");
    resourceLoaded = await AppConstant.loadResources();
    setState(() {});
  }

  void showMessage(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(title: Text(errorMessage));
      },
    );
  }

  void _signUserIn() async {
    _fbKey.currentState!.save();
    if (_fbKey.currentState!.saveAndValidate()) {
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      try {
        await FirebaseAuthRepository.signInWithEmailAndPassword(context,
            email: _emailInput.text, password: _passwordInput.text);
        if (selectedRole == "admin" && Get.find<AppUser>().role == "admin") {
          Get.offAllNamed(RouteHelper.getAdminHome());
        } else if (selectedRole == "patient" &&
            Get.find<AppUser>().role == "patient") {
          Get.offAllNamed(RouteHelper.getPatientHome());
        } else {
          Get.back(); // Close the loading dialog
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Column(
                  children: [
                    // Customize the content for the other role here
                    Image.asset(AppConstant.WRONG_MARK, width: 100.w),
                    SizedBox(height: 10.h),
                    Text(
                      "You don't have permission for this role!",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.h3,
                    ),
                  ],
                ),
              );
            },
          );
        }
      } on FirebaseAuthException catch (e) {
        Get.back(); // Close the loading dialog
        print(e.code);
        switch (e.code) {
          case 'invalid-email':
            showMessage("Invalid email. Please try again.");
            break;
          case 'wrong-password':
            showMessage("Wrong password. Please try again.");
            break;
          case 'user-not-found':
            showMessage("User not found. Please sign up first.");
            break;
          case 'user-disabled':
            showMessage("User has been disabled.");
            break;
          case 'too-many-requests':
            showMessage("Too many requests. Please try again later.");
            break;
        }
      }
    } else {
      print("validation failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: resourceLoaded
            ? SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 32.h, horizontal: 16.w),
                  child: FormBuilder(
                    key: _fbKey,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: DropdownButton<String>(
                              value: selectedRole,
                              items: const [
                                DropdownMenuItem<String>(
                                  value: "patient",
                                  child: Text("patient"),
                                ),
                                DropdownMenuItem<String>(
                                  value: "admin",
                                  child: Text("admin"),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedRole = value!;
                                });
                              },
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            children: [
                              Image.asset(AppConstant.NEUROFIT_LOGO_ONLY,
                                  width: 100.w),
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
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: "Please enter your email",
                            ),
                            FormBuilderValidators.email(
                                errorText: "Your email is not valid!"),
                          ]),
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
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: "Password is required!"),
                          ]),
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
                                    onTap: () {
                                      if (selectedRole == "admin") {}
                                      Get.offAllNamed(
                                          RouteHelper.getSignUpFirstPage());
                                    },
                                    child: Text(
                                      "Sign Up",
                                      style: AppTextStyle.h3.merge(
                                          AppTextStyle.brandBlueTextStyle.merge(
                                              AppTextStyle.underlineTextStyle)),
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
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
