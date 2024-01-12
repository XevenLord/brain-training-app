import 'package:brain_training_app/patient/appointment/ui/view_model/appointment_vmodel.dart';
import 'package:brain_training_app/patient/appointment/ui/widget/doctor_card.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppointmentMainPage extends StatefulWidget {
  const AppointmentMainPage({super.key});

  @override
  State<AppointmentMainPage> createState() => _AppointmentMainPageState();
}

class _AppointmentMainPageState extends State<AppointmentMainPage> {
  late AppointmentViewModel appointmentViewModel;
  List<AppUser> physiotherapists = [];

  @override
  void initState() {
    super.initState();
    appointmentViewModel = Get.find<AppointmentViewModel>();
    physiotherapists = appointmentViewModel.physiotherapistList;
    print("physiotherapists: $physiotherapists");
  }

  @override
  Widget build(BuildContext context) {
    return physiotherapists.isEmpty
        ? const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : SingleChildScrollView(
            key: PageStorageKey("appts"),
            child: Column(
              children: [
                Text("Select a practitioner", style: AppTextStyle.h3),
                SizedBox(height: 16.h),
                GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16.w,
                    shrinkWrap: true, // Add this line
                    physics:
                        const NeverScrollableScrollPhysics(), // Add this line
                    children: [
                      ...List.generate(
                        physiotherapists.length,
                        (index) => DoctorCard(
                          doctorName: physiotherapists[index].name!,
                          position: physiotherapists[index].position!,
                          imgUrl: physiotherapists[index].profilePic!,
                          rating: 5.0,
                          onTap: () {
                            appointmentViewModel.setChosenPhysiotherapist(
                              physiotherapist: physiotherapists[index],
                            );
                            Get.toNamed(
                                RouteHelper.getAppointmentBookingPage());
                          },
                        ),
                      ),
                    ]),
                SizedBox(height: 32.h),
              ],
            ),
          );
  }
}
