import 'package:brain_training_app/admin/appointments/domain/entity/appointment.dart';
import 'package:brain_training_app/admin/appointments/ui/view_model/appointment_vmodel.dart';
import 'package:brain_training_app/common/domain/service/user_repo.dart';
import 'package:brain_training_app/common/ui/widget/input_text_field.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/utils/app_constant.dart';
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
  AppUser patient;
  AdminAppointmentEditPage(
      {super.key, required this.appointment, required this.patient});

  @override
  State<AdminAppointmentEditPage> createState() =>
      _AdminAppointmentEditPageState();
}

class _AdminAppointmentEditPageState extends State<AdminAppointmentEditPage> {
  GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  late AdminAppointmentViewModel appointmentVModel;
  DateTime intialDate = DateTime.now().add(Duration(days: 1));
  String? time;
  late AppUser patient;
  AppUser? admin;
  List<AdminAppointment> appts = [];

  List timeSlots = [];
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
  TextEditingController remarkController = TextEditingController();
  TextEditingController adminController = TextEditingController();

  @override
  void initState() {
    appointmentVModel = Get.find<AdminAppointmentViewModel>();
    patient = widget.patient;
    admin = UserRepository.admins.firstWhere(
        (element) => element.uid == widget.appointment.physiotherapistID);

    appts = appointmentVModel.appointments
        .where((element) =>
            element.physiotherapistID == widget.appointment.physiotherapistID)
        .toList();
    updateTimeSlots();
    dateController.text = widget.appointment.date!;
    reasonController.text = widget.appointment.reason ?? "";
    remarkController.text = widget.appointment.remark ?? "";
    adminController.text = admin?.name ?? "";
    time = widget.appointment.time!;
    super.initState();
  }

  void updateAppointment() async {
    if (_fbKey.currentState!.saveAndValidate()) {
      await appointmentVModel.updateAppointment(
        appointment: widget.appointment,
        date: dateController.text,
        reason: reasonController.text,
        remark: remarkController.text,
        time: time!,
      );
    }
    Get.back(result: true);
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

  void deleteAppointment() async {
    await appointmentVModel.cancelAppointment(appointment: widget.appointment);
    Get.back(result: true);
  }

  bool isAfterToday(DateTime date) {
    return date.isAfter(DateTime.now());
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
                                backgroundColor: AppColors.lightBlue,
                                backgroundImage: patient.profilePic == null ||
                                        patient.profilePic!.isEmpty
                                    ? const AssetImage(
                                        AppConstant.NO_PROFILE_PIC,
                                      ) as ImageProvider
                                    : NetworkImage(
                                        patient.profilePic!,
                                      ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                patient.name!,
                                style: AppTextStyle.h2,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              SizedBox(height: 8.h),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      InputTextFormField(
                        name: "admin",
                        textEditingController: adminController,
                        promptText: "Admin",
                        label: "Select your admin",
                        textAlign: TextAlign.center,
                        initialValue: admin!.name,
                        readOnly: true,
                      ),
                      SizedBox(height: 16.h),
                      InputTextFormField(
                        name: "date",
                        promptText: "Appointment Date",
                        textEditingController: dateController,
                        label: "DD/MM/YYYY",
                        keyboardType: TextInputType.datetime,
                        textAlign: TextAlign.center,
                        readOnly: !isAfterToday(
                            DateTime.parse(widget.appointment.date!)),
                        onTap: () async {
                          if (isAfterToday(
                              DateTime.parse(widget.appointment.date!))) {
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
                          }
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
                        items: timeSlots.cast<String>(),
                        label: "Select your appointment time",
                        initialValue: widget.appointment.time,
                        readOnly: !isAfterToday(
                            DateTime.parse(widget.appointment.date!)),
                        onChanged: (value) {
                          if (isAfterToday(
                              DateTime.parse(widget.appointment.date!))) {
                            setState(() {
                              time = value;
                            });
                          }
                        },
                      ),
                      InputTextFormField(
                        name: "reason",
                        promptText: "Appointment Reason",
                        label: "Tell us about your reason for appointment",
                        textEditingController: reasonController,
                        maxLines: null,
                      ),
                      InputTextFormField(
                        name: "remark",
                        promptText: "Remark (Fill if appointment is completed)",
                        label:
                            "Write the condition of the patient throuhout the appointment",
                        textEditingController: remarkController,
                        maxLines: 15,
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
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Appointment'),
                                  content: const Text(
                                      'Are you sure you want to delete this appointment?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                        deleteAppointment();
                                      },
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                ),
                              );
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
