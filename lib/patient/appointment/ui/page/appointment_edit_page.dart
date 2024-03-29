import 'dart:async';

import 'package:brain_training_app/common/ui/widget/input_text_field.dart';
import 'package:brain_training_app/patient/appointment/domain/entity/appointment.dart';
import 'package:brain_training_app/patient/appointment/ui/view_model/appointment_vmodel.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppointmentEditPage extends StatefulWidget {
  Appointment appointment;
  AppointmentEditPage({super.key, required this.appointment});

  @override
  State<AppointmentEditPage> createState() => _AppointmentEditPageState();
}

class _AppointmentEditPageState extends State<AppointmentEditPage> {
  GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  late AppointmentViewModel appointmentVModel;
  DateTime intialDate = DateTime.now().add(Duration(days: 1));
  String? time;
  late AppUser physiotherapist;
  List<Appointment> appts = [];

  List<String> timeSlots = [];
  List<String> timeSlotsTemplate = [
    "09:00 AM",
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "01:00 PM",
    "02:00 PM",
    "03:00 PM",
    "04:00 PM",
    "05:00 PM",
  ];

  TextEditingController dateController = TextEditingController();
  TextEditingController reasonController = TextEditingController();

  final appUser = Get.find<AppUser>();

  @override
  void initState() {
    super.initState();
    appointmentVModel = Get.find<AppointmentViewModel>();
    physiotherapist = appointmentVModel.physiotherapistList.firstWhere(
        (element) => element.uid == widget.appointment.physiotherapistID);
    appts = appointmentVModel.appointments
        .where((element) =>
            element.physiotherapistID == widget.appointment.physiotherapistID)
        .toList();
    updateTimeSlots();
    dateController.text = widget.appointment.date!;
    reasonController.text = widget.appointment.reason!;
    time = widget.appointment.time!;
  }

  void updateTimeSlots() {
    timeSlots = List.from(timeSlotsTemplate);
    for (int i = 0; i < appts.length; i++) {
      if (appts[i].date != null && appts[i].date! == widget.appointment.date) {
        if (appts[i].time != widget.appointment.time) {
          timeSlots.remove(appts[i].time);
        }
      }
    }
    setState(() {});
  }

  void updateAppointment() async {
    reasonController.text = reasonController.text.trim();
    _fbKey.currentState!.save();
    if (_fbKey.currentState!.saveAndValidate()) {
      await appointmentVModel.updateAppointment(
        appointment: widget.appointment,
        date: dateController.text,
        reason: reasonController.text,
        time: time!,
      );
    }
    Get.toNamed(RouteHelper.getMyAppointmentPage());
  }

  void deleteAppointment() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Appointment", style: AppTextStyle.h2),
          content: Text("Are you sure you want to delete this appointment?",
              style: AppTextStyle.h3),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await appointmentVModel.cancelAppointment(
                    appointment: widget.appointment);
                Get.toNamed(RouteHelper.getMyAppointmentPage());
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 16.w),
                child: FormBuilder(
                  key: _fbKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 70.r,
                                backgroundImage: (physiotherapist.profilePic ==
                                            null ||
                                        physiotherapist.profilePic!.isEmpty)
                                    ? const AssetImage(
                                        AppConstant.NO_PROFILE_PIC,
                                      ) as ImageProvider
                                    : NetworkImage(physiotherapist.profilePic!),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                physiotherapist.name!,
                                style: AppTextStyle.h2,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                physiotherapist.position!,
                                style: AppTextStyle.c1,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      InputTextFormField(
                        name: "date",
                        promptText: "Appointment Date",
                        textEditingController: dateController,
                        label: "DD/MM/YYYY",
                        keyboardType: TextInputType.datetime,
                        textAlign: TextAlign.center,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: intialDate,
                              firstDate: intialDate,
                              lastDate: DateTime(2025));

                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            setState(() {
                              dateController.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {}
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: "Select your appointment date",
                          ),
                          FormBuilderValidators.dateString(),
                        ]),
                      ),
                      InputTextFormField(
                        name: "time",
                        promptText: "Appointment Time",
                        isDropdown: true,
                        items: timeSlots,
                        label: "Select your appointment time",
                        initialValue: widget.appointment.time,
                        onChanged: (value) {
                          setState(() {
                            time = value;
                          });
                        },
                      ),
                      InputTextFormField(
                        name: "reason",
                        promptText: "Appointment Reason",
                        label: "Tell us about your reason for appointment",
                        textEditingController: reasonController,
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
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.white),
                            child: Text(
                              "Cancel",
                              style: AppTextStyle.h3
                                  .merge(AppTextStyle.brandBlueTextStyle),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          ElevatedButton(
                            onPressed: () {
                              deleteAppointment();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.brandRed),
                            child: Text(
                              "Delete",
                              style: AppTextStyle.h3
                                  .merge(AppTextStyle.whiteTextStyle),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          ElevatedButton(
                            onPressed: () {
                              updateAppointment();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.brandBlue),
                            child: Text(
                              "Update",
                              style: AppTextStyle.h3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
