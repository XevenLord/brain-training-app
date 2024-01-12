import 'package:brain_training_app/admin/appointments/domain/entity/appointment.dart';
import 'package:brain_training_app/admin/appointments/ui/view_model/appointment_vmodel.dart';
import 'package:brain_training_app/common/ui/widget/info_card.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppointmentViewRequests extends StatefulWidget {
  List<AdminAppointment> appointments;
  List<AppUser> patients;
  AppointmentViewRequests(
      {super.key, required this.appointments, required this.patients});

  @override
  State<AppointmentViewRequests> createState() =>
      _AppointmentViewRequestsState(appointments, patients);
}

class _AppointmentViewRequestsState extends State<AppointmentViewRequests> {
  List<AdminAppointment>? appointments;
  List<AppUser>? patients;
  late AdminAppointmentViewModel apptVModel;

  _AppointmentViewRequestsState(this.appointments, this.patients);
  @override
  void initState() {
    apptVModel = Get.find<AdminAppointmentViewModel>();
    super.initState();
  }

  String calculateAge(DateTime? dateOfBirth) {
    if (dateOfBirth == null) {
      return 'N/A';
    }

    final currentDate = DateTime.now();
    final age = currentDate.year - dateOfBirth.year;

    if (currentDate.month < dateOfBirth.month ||
        (currentDate.month == dateOfBirth.month &&
            currentDate.day < dateOfBirth.day)) {
      return (age - 1)
          .toString(); // Subtract 1 if birthday hasn't occurred this year yet
    }
    return age.toString();
  }

  void onApproveAppointment(AdminAppointment appointment) {
    apptVModel.approveAppointment(appointment: appointment);
    if (appointments != null && appointments!.isNotEmpty) {
      appointments!.remove(appointment);
    }
    setState(() {});
  }

  void onDeclineAppointment(AdminAppointment appointment) {
    apptVModel.declineAppointment(appointment: appointment);
    if (appointments != null && appointments!.isNotEmpty) {
      appointments!.remove(appointment);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
        elevation: 0,
        title: Text('Appointment Requests', style: AppTextStyle.h2),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: appointments == null || appointments!.isEmpty
              ? displayEmptyDataLoaded("There is no pending appointment.",
                  showBackArrow: false)
              : ListView.builder(
                  itemCount: appointments!.length,
                  itemBuilder: (context, index) {
                    AdminAppointment appointment = appointments![index];
                    AppUser patient = patients!.where((element) {
                      return element.uid == appointment.patientID;
                    }).first;
                    return InfoCardTile().buildRequestCard(
                      name: patient.name!,
                      gender: patient.gender!,
                      age: calculateAge(patient.dateOfBirth),
                      imgUrl: patient.profilePic!,
                      date: appointment.date!,
                      time: appointment.time!,
                      reason: appointment.reason!,
                      onAccept: () {
                        onApproveAppointment(appointment);
                      },
                      onDecline: () {
                        onDeclineAppointment(appointment);
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }
}
