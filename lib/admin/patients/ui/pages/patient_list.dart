import 'package:brain_training_app/admin/appointments/domain/entity/appointment.dart';
import 'package:brain_training_app/admin/appointments/ui/view_model/appointment_vmodel.dart';
import 'package:brain_training_app/common/domain/service/user_repo.dart';
import 'package:brain_training_app/common/ui/widget/info_card.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PatientList extends StatefulWidget {
  const PatientList({super.key});

  @override
  State<PatientList> createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  late UserRepository userRepo;
  late List<AppUser> patients;
  late AdminAppointmentViewModel adminAppointmentViewModel;
  List<AdminAppointment> appointments = [];

  bool isLoading = true;

  @override
  void initState() {
    userRepo = Get.find<UserRepository>();
    adminAppointmentViewModel = Get.find<AdminAppointmentViewModel>();
    appointments = adminAppointmentViewModel.appointments;
    fetchPatients();
    super.initState();
  }

  void fetchPatients() async {
    try {
      patients = await UserRepository.fetchAllPatients();
      setState(() {
        isLoading = false; // Set loading to false after data is fetched
      });
    } catch (e) {
      // Handle any potential errors during data fetching
      setState(() {
        isLoading = false; // Set loading to false even on error
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text("Patient List",
              style: AppTextStyle.brandBlueTextStyle.merge(AppTextStyle.h2)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.brandBlue),
          onPressed: () => Get.back(), // Or Get.back() if using GetX
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...patients.map((e) {
                        AdminAppointment appt;

                        try {
                          appt = appointments
                              .where((element) =>
                                  element.patientID == e.uid &&
                                  element.remark != null &&
                                  element.remark!.isNotEmpty)
                              .reduce((current, next) =>
                                  DateTime.parse(current.date!)
                                          .isAfter(DateTime.parse(next.date!))
                                      ? current
                                      : next);
                        } catch (e) {
                          appt = AdminAppointment();
                        }
                        return InfoCardTile().buildInfoCard(
                          shout: true,
                          name: e.name!,
                          age: calculateAge(e.dateOfBirth),
                          gender: e.gender!,
                          onShout: () {
                            Get.toNamed(RouteHelper.getPatientShoutPage(),
                                arguments: e);
                          },
                          onEdit: () {
                            Get.toNamed(RouteHelper.getPatientOverviewPage(),
                                arguments: [e, appt]);
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
