import 'package:brain_training_app/admin/appointments/domain/entity/appointment.dart';
import 'package:brain_training_app/admin/appointments/ui/view_model/appointment_vmodel.dart';
import 'package:brain_training_app/common/ui/widget/input_text_field.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AdminAppointmentEditPage extends StatefulWidget {
  AdminAppointment appointment;
  AdminAppointmentEditPage({super.key, required this.appointment});

  @override
  State<AdminAppointmentEditPage> createState() =>
      _AdminAppointmentEditPageState();
}

class _AdminAppointmentEditPageState extends State<AdminAppointmentEditPage> {
  GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  late AdminAppointmentViewModel appointmentVModel;
  String? time;
  late AppUser physiotherapist;

  List<String> timeSlots = [
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

  @override
  void initState() {
    super.initState();
    appointmentVModel = Get.find<AdminAppointmentViewModel>();
    physiotherapist = appointmentVModel.physiotherapistList.firstWhere(
        (element) => element.uid == widget.appointment.physiotherapistID);
    dateController.text = widget.appointment.date!;
    reasonController.text = widget.appointment.reason!;
    time = widget.appointment.time!;
  }

  void updateAppointment() async {
    if (_fbKey.currentState!.saveAndValidate()) {
      await appointmentVModel.updateAppointment(
        appointment: widget.appointment,
        date: dateController.text,
        reason: reasonController.text,
        time: time!,
      );
    }
    Get.back(result: true);
  }

  void deleteAppointment() async {
    await appointmentVModel.cancelAppointment(appointment: widget.appointment);
    Get.back(result: true);
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
                                backgroundImage: NetworkImage(
                                  physiotherapist.profilePic!,
                                ),
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
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2100));

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
