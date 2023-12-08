import 'dart:async';
import 'dart:io';

import 'package:brain_training_app/common/ui/widget/input_text_field.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/profile/ui/view_model/profile_vmodel.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/cupertino.dart';
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
    _fbKey.currentState!.save();
    if (_fbKey.currentState!.saveAndValidate()) {
      await profileVModel.updateProfile(_fbKey.currentState!.value);
      Get.offAllNamed(RouteHelper.getPatientHome(), arguments: 3);
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
                        SizedBox(height: 16.h),
                        Text("Edit Profile", style: AppTextStyle.h2),
                        SizedBox(height: 16.h),
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
                                              profileVModel
                                                  .takeImageFromCamera();
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(
                                              Icons.photo,
                                              color: AppColors.brandBlue,
                                            ),
                                            title: Text("Gallery"),
                                            onTap: () {
                                              Navigator.pop(context);
                                              profileVModel
                                                  .takeImageFromGallery();
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            });
                            print("The image has changed");
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: Obx(
                              () => FutureBuilder<File?>(
                                future:
                                    Future.value(profileVModel.imagefile.value),
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
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.file(
                                          snapshot.data!,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    );
                                  } else if (appUser.profilePic != null) {
                                    // If no new image is available but appUser has a profilePic,
                                    // load the image from appUser.profilePic
                                    return CircleAvatar(
                                      radius: 70.r,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(69.r),
                                        child: Image(
                                          image:
                                              NetworkImage(appUser.profilePic!),
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
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
                          style: AppTextStyle.h3
                              .merge(AppTextStyle.brandBlueTextStyle),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.lightBlue),
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
