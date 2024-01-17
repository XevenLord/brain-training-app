import 'dart:io';

import 'package:brain_training_app/admin/patients/domain/entity/inspirational_mssg.dart';
import 'package:brain_training_app/admin/patients/ui/pages/patient_insmssg.dart';
import 'package:brain_training_app/admin/patients/ui/view_model/patient_vmodel.dart';
import 'package:brain_training_app/common/ui/widget/input_text_field.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:brain_training_app/utils/use_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PatientShoutPage extends StatefulWidget {
  AppUser? patient;
  PatientShoutPage({super.key, this.patient});

  @override
  State<PatientShoutPage> createState() => _PatientShoutPageState();
}

class _PatientShoutPageState extends State<PatientShoutPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  late AppUser patient;
  late ManagePatientViewModel managePatientVM;
  TextEditingController nameController = TextEditingController();
  TextEditingController shoutController = TextEditingController();
  int maxLines = 5;

  @override
  void initState() {
    managePatientVM = Get.find<ManagePatientViewModel>();
    patient = widget.patient!;
    managePatientVM.setPatient(patient);
    super.initState();
  }

  void sendMessage() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Image.asset(AppConstant.LOADING_GIF, height: 100.w);
      },
    );
    _fbKey.currentState!.save();
    if (_fbKey.currentState!.saveAndValidate()) {
      Map<String, dynamic> data = new Map<String, dynamic>.from(
          _fbKey.currentState!.value as Map<String, dynamic>);
      data.addEntries(
          {'receiverUid': patient.uid, 'createdAt': Timestamp.now()}.entries);
      managePatientVM.setDetails(data);
      bool res = await managePatientVM.onPushInspirationalMessage();
      if (res) {
        Get.back();
        nameController.clear();
        shoutController.clear();
        useInfoDialog(
          title: "Uploaded Successfully",
          content: Image.asset(AppConstant.DONE_CHECK, height: 100.w),
          confirmButtonText: "OK",
          onConfirm: () {
            Get.back();
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFE0B2), // Light warm yellow
                Color(0xFFFFCC80), // Slightly deeper warm yellow
              ],
            ),
          ),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back_ios, color: Colors.black),
                ),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.view_headline_rounded,
                          color: Colors.black),
                      onPressed: () {
                        Get.to(() =>
                            PatientInspirationalMessagePage(patient: patient));
                      }),
                  IconButton(
                      icon: Icon(Icons.info, color: Colors.black),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  title: Text("Inspirational Message"),
                                  content: Text(
                                      "Leave a collection of thoughtful messages for the patient. These messages are here to inspire and motivate him or her in the recovery."),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Get.back(),
                                        child: Text("I Understand"))
                                  ],
                                ));
                      }),
                ],
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Image.asset(AppConstant.SUPPORTIVE_IMG),
                    Text(
                      '"${patient.name} Need Your Support!"',
                      style: AppTextStyle.h2,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.w),
                    FormBuilder(
                      key: _fbKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            InputTextFormField(
                              // expands: true,
                              name: "sender",
                              promptText: "Who are you?",
                              label: "Write your name",
                              textEditingController: nameController,
                              maxLines: null,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Please enter the name",
                                ),
                                FormBuilderValidators.minLength(2,
                                    errorText: "The name is too short!"),
                              ]),
                            ),
                            InputTextFormField(
                              // expands: true,
                              name: "message",
                              promptText: "Any message ",
                              label: "Write description",
                              textEditingController: shoutController,
                              maxLines: null,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Please enter description",
                                ),
                                FormBuilderValidators.minLength(10,
                                    errorText: "The description is too short!"),
                              ]),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                  "Send your picture to ${patient.name} (Optional)",
                                  style: AppTextStyle.h3),
                            ),
                            CupertinoButton(
                              onPressed: () {
                                setState(() {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: 150.h,
                                          width: 250.h,
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
                                                  managePatientVM
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
                                                  managePatientVM
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
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.lightYellow,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 25.w, horizontal: 10.w),
                                  child: Obx(
                                    () => FutureBuilder<File?>(
                                      future: Future.value(
                                          managePatientVM.imagefile.value),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          // While the image is loading, you can display a placeholder
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                            ),
                                            width: 250.w,
                                            height: 100,
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: Colors.grey[800],
                                            ),
                                          );
                                        } else if (snapshot.hasError) {
                                          // Handle any errors that occurred during loading
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else if (snapshot.data != null) {
                                          // If the image is available, display it
                                          return Container(
                                            height: 200.w,
                                            width: 280.w,
                                            child: ClipRRect(
                                              child: Image.file(
                                                snapshot.data!,
                                                width: 150,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          );
                                        } else {
                                          // If no image is available, display a default image or icon
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.lightYellow,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            width: 250.w,
                                            height: 120.w,
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: Colors.grey[800],
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.w),
                            CupertinoButton(
                              onPressed: () {
                                sendMessage();
                              },
                              child: Text(
                                "Send Message",
                                style: AppTextStyle.h2
                                    .copyWith(color: AppColors.brandYellow),
                              ),
                              color: AppColors.lightYellow,
                            ),
                            SizedBox(height: 20.w)
                          ],
                        ),
                      ),
                    ),
                    // ... rest of your widgets ...
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
