import 'dart:io';

import 'package:brain_training_app/common/ui/widget/input_segmented_control.dart';
import 'package:brain_training_app/common/ui/widget/input_text_field.dart';
import 'package:brain_training_app/patient/authentification/signUp/ui/view_model/sign_up_controller.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AdminRegisterPage extends StatefulWidget {
  const AdminRegisterPage({super.key});

  @override
  State<AdminRegisterPage> createState() => _AdminRegisterPageState();
}

class _AdminRegisterPageState extends State<AdminRegisterPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  late SignUpController signUpController;

  int genderValue = 0;
  List<String> genderList = ["Male", "Female"];

  final TextEditingController _nameInput = TextEditingController();
  final TextEditingController _icInput = TextEditingController();
  final TextEditingController _emailInput = TextEditingController();
  final TextEditingController _phoneInput = TextEditingController();
  final TextEditingController _dOBInput = TextEditingController();
  final TextEditingController _passwordInput = TextEditingController();
  final TextEditingController _confirmPasswordInput = TextEditingController();
  final TextEditingController introController = TextEditingController();

  bool obscureText = true;
  bool obscureTextConfirm = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    signUpController = Get.find<SignUpController>();
  }

  bool checkPassword() {
    bool isCorrect = true;
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    if (_passwordInput.text != _confirmPasswordInput.text) {
      isCorrect = false;
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
    }
    return isCorrect;
  }

  void signUp() async {
    bool res = false;
    if (checkPassword() == false) return;
    _fbKey.currentState!.save();
    if (_fbKey.currentState!.saveAndValidate()) {
      Map<String, dynamic> data = new Map();
      data.addAll(_fbKey.currentState!.value);
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
      res = await signUpController.adminSignUpWithData(data);
    }

    if (res) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Column(
                children: [
                  Image.asset(AppConstant.APPOINTMENT_SUCCESS, width: 100.w),
                  SizedBox(height: 10.h),
                  Text("Admin account created successfully",
                      textAlign: TextAlign.center, style: AppTextStyle.h3),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.offNamed(RouteHelper.getAdminListPage());
                  },
                  child: Text('OK', style: AppTextStyle.h3),
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
        title: const Text("Admin Register"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.brandBlue),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            child: FormBuilder(
              key: _fbKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text("Create Admin Account", style: AppTextStyle.h2),
                        SizedBox(height: 30.h),
                        CupertinoButton(
                          onPressed: () {
                            setState(() {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 150.h,
                                      child: Column(
                                        children: [
                                          ListTile(
                                            leading: const Icon(
                                              Icons.camera_alt,
                                              color: AppColors.brandBlue,
                                            ),
                                            title: Text("Camera"),
                                            onTap: () {
                                              Navigator.pop(context);
                                              signUpController
                                                  .takeImageFromCamera();
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(
                                              Icons.photo,
                                              color: AppColors.brandBlue,
                                            ),
                                            title: Text("Gallery"),
                                            onTap: () {
                                              Navigator.pop(context);
                                              signUpController
                                                  .takeImageFromGallery();
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: Obx(
                              () => FutureBuilder<File?>(
                                future: Future.value(
                                    signUpController.imagefile.value),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // While the image is loading, you can display a placeholder
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      width: 100,
                                      height: 100,
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey[800],
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    // Handle any errors that occurred during loading
                                    return Text('Error: ${snapshot.error}');
                                  } else if (snapshot.data != null) {
                                    // If the image is available, display it
                                    return CircleAvatar(
                                      radius: 60,
                                      backgroundImage: Image.file(
                                        snapshot.data!,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.fill,
                                      ).image,
                                    );
                                  } else {
                                    // If no image is available, display a default image or icon
                                    return CircleAvatar(
                                      radius: 60,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        width: 100,
                                        height: 100,
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InputTextFormField(
                    name: "name",
                    promptText: "Full Name",
                    textEditingController: _nameInput,
                    label: "Enter Full Name",
                    keyboardType: TextInputType.name,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: "Please enter the name",
                      ),
                      FormBuilderValidators.minLength(2,
                          errorText: "The name is too short!"),
                    ]),
                  ),
                  InputTextFormField(
                    name: "ic",
                    promptText: "No. IC",
                    textEditingController: _icInput,
                    label: "Enter No. IC",
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: "Please enter IC number",
                      ),
                      FormBuilderValidators.equalLength(12,
                          errorText: "The IC number is not valid!")
                    ]),
                  ),
                  InputTextFormField(
                    name: "email",
                    promptText: "Email",
                    textEditingController: _emailInput,
                    label: "Enter Email",
                    keyboardType: TextInputType.emailAddress,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: "Please enter email",
                      ),
                      FormBuilderValidators.email(
                          errorText: "The email is not valid!"),
                    ]),
                  ),
                  InputTextFormField(
                    name: "phone",
                    promptText: "Mobile Number",
                    textEditingController: _phoneInput,
                    label: "Enter Phone Number",
                    keyboardType: TextInputType.phone,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: "Please enter phone number",
                      ),
                      FormBuilderValidators.numeric(),
                    ]),
                  ),
                  InputTextFormField(
                    name: "dob",
                    promptText: "Date of Birth",
                    textEditingController: _dOBInput,
                    label: "DD/MM/YYYY",
                    keyboardType: TextInputType.datetime,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2100));

                      if (pickedDate != null) {
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        setState(() {
                          _dOBInput.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {}
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: "Select date of birth",
                      ),
                      FormBuilderValidators.dateString(),
                    ]),
                  ),
                  InputFormSegmentedControl(
                    name: "gender",
                    fieldName: "Gender",
                    options: List.generate(
                        genderList.length,
                        (index) => FormBuilderFieldOption(
                            value: genderList[index],
                            child: Text(genderList[index],
                                style: AppTextStyle.h3))).toList(),
                  ),
                  // Password and Confirm Password
                  SizedBox(height: 30.h),
                  InputTextFormField(
                    name: "aboutMe",
                    promptText: "Physiotherapist's bio",
                    label: "Write description",
                    textEditingController: introController,
                    maxLines: null,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: "Please enter description",
                      ),
                      FormBuilderValidators.minLength(10,
                          errorText: "The description is too short!"),
                    ]),
                  ),
                  SizedBox(height: 18.h),
                  InputTextFormField(
                    obscureText: obscureText,
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      child: const Icon(Icons.remove_red_eye),
                    ),
                    name: "password",
                    promptText: "Password",
                    textEditingController: _passwordInput,
                    label: "Enter Password",
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
                      child: const Icon(Icons.remove_red_eye),
                    ),
                    name: "confirmPassword",
                    promptText: "Confirm Password",
                    textEditingController: _confirmPasswordInput,
                    label: "Enter Password Again",
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
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            signUp();
                            Get.back();
                          },
                          child: Text(
                            "Sign Up",
                            style: AppTextStyle.h3,
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.brandBlue),
                        ),
                        SizedBox(height: 10.h),
                      ],
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
