import 'dart:async';

import 'package:brain_training_app/common/ui/widget/input_text_field.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/profile/ui/view_model/profile_vmodel.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  late ProfileViewModel profileVModel;

  TextEditingController nameController = TextEditingController();
  TextEditingController icController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController introController = TextEditingController();

  final appUser = Get.find<AppUser>();

  @override
  void initState() {
    super.initState();
    profileVModel = Get.find<ProfileViewModel>();
    nameController.text = appUser.name!;
    icController.text = appUser.icNumber!;
    emailController.text = appUser.email!;
    phoneController.text = appUser.phoneNumber!;
    genderController.text = appUser.gender!;
    dobController.text = DateFormat("yyyy-MM-dd").format(appUser.dateOfBirth!);
    if (appUser.aboutMe != null) introController.text = appUser.aboutMe!;
  }

  void updateProfile() async {
    if (introController.text == null)
      _fbKey.currentState!.fields["aboutMe"]!.didChange(null);
    print("check null of about");
    print(_fbKey.currentState!.value["aboutMe"] == null);
    _fbKey.currentState!.save();
    if (_fbKey.currentState!.saveAndValidate()) {
      await profileVModel.updateProfile(_fbKey.currentState!.value);
      print("back to profile page...");
      Get.offAllNamed(RouteHelper.getPatientHome(), arguments: 3);
    } else {
      print("validation failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        Image.asset(AppConstant.NEUROFIT_LOGO_ONLY,
                            width: 80.w),
                        SizedBox(height: 16.h),
                        Text("Edit Profile", style: AppTextStyle.h2),
                      ],
                    ),
                  ),
                  InputTextFormField(
                    name: "name",
                    promptText: "Name",
                    textEditingController: nameController,
                    label: "Enter Your Full Name",
                    keyboardType: TextInputType.name,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: "Please enter your name",
                      ),
                      FormBuilderValidators.minLength(2,
                          errorText: "Your name is too short!"),
                    ]),
                  ),
                  InputTextFormField(
                    name: "icNumber",
                    promptText: "IC Number",
                    textEditingController: icController,
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: "Please enter your IC number",
                      ),
                      FormBuilderValidators.equalLength(12,
                          errorText: "Your IC number is not valid!")
                    ]),
                  ),
                  InputTextFormField(
                    name: "email",
                    promptText: "Email",
                    textEditingController: emailController,
                    readOnly: true,
                  ),
                  InputTextFormField(
                    name: "phoneNumber",
                    promptText: "Phone Number",
                    textEditingController: phoneController,
                    label: "Enter Your Phone Number",
                    keyboardType: TextInputType.phone,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: "Please enter your phone number",
                      ),
                      FormBuilderValidators.numeric(),
                    ]),
                  ),
                  InputTextFormField(
                    name: "dateOfBirth",
                    promptText: "Date of Birth",
                    textEditingController: dobController,
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
                          dobController.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {}
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: "Select your date of birth",
                      ),
                      FormBuilderValidators.dateString(),
                    ]),
                  ),
                  InputTextFormField(
                    name: "aboutMe",
                    promptText: "About You",
                    label: "Tell us about yourself",
                    textEditingController: introController,
                    maxLines: null,
                  ),
                  SizedBox(height: 30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(
                          "Cancel",
                          style: AppTextStyle.h3
                              .merge(AppTextStyle.brandBlueTextStyle),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.white),
                      ),
                      SizedBox(width: 16.w),
                      ElevatedButton(
                        onPressed: () {
                          updateProfile();
                        },
                        child: Text(
                          "Update",
                          style: AppTextStyle.h3,
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brandBlue),
                      ),
                    ],
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
